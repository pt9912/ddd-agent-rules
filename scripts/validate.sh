#!/usr/bin/env bash

set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
validation_tmp="$(mktemp -d)"
trap 'rm -rf "$validation_tmp"' EXIT

failures=0

fail() {
    printf 'FEHLER: %s\n' "$1" >&2
    failures=$((failures + 1))
}

front_matter_value() {
    local key="$1"
    local file="$2"
    awk -v key="$key" '
        NR == 1 && $0 == "---" { in_front_matter = 1; next }
        in_front_matter && $0 == "---" { exit }
        in_front_matter && index($0, key ": ") == 1 {
            print substr($0, length(key) + 3)
            exit
        }
    ' "$file"
}

front_matter_has_key() {
    local key="$1"
    local file="$2"
    awk -v key="$key" '
        NR == 1 && $0 == "---" { in_front_matter = 1; next }
        in_front_matter && $0 == "---" { exit }
        in_front_matter && ($0 == key ":" || index($0, key ": ") == 1) { found = 1 }
        END { exit !found }
    ' "$file"
}

count_bullets() {
    local heading="$1"
    local file="$2"
    awk -v heading="## $heading" '
        $0 == heading { inside = 1; next }
        /^## / { inside = 0 }
        inside && /^- / { n++ }
        END { print n + 0 }
    ' "$file"
}

rule_ids="$validation_tmp/rule-ids"
: > "$rule_ids"
superseded_rules="$validation_tmp/superseded-rules"
: > "$superseded_rules"

for rule_file in "$project_root"/rules/*.md; do
    relative_file="${rule_file#"$project_root"/}"
    first_line="$(sed -n '1p' "$rule_file")"
    rule_id="$(front_matter_value id "$rule_file")"
    priority="$(front_matter_value priority "$rule_file")"
    status="$(front_matter_value status "$rule_file")"
    superseded_by="$(front_matter_value superseded_by "$rule_file")"

    title="$(front_matter_value title "$rule_file")"
    [[ "$first_line" == "---" ]] || fail "$relative_file muss mit YAML-Front-Matter beginnen"
    [[ -n "$rule_id" ]] || fail "$relative_file enthält keine id"
    [[ -n "$title" ]] || fail "$relative_file enthält keinen title"
    [[ -n "$(front_matter_value category "$rule_file")" ]] || fail "$relative_file enthält keine category"
    front_matter_has_key applies_to "$rule_file" || fail "$relative_file enthält kein applies_to"

    if [[ -n "$rule_id" && -n "$title" ]]; then
        inhalt_entry="[$rule_id – $title]($relative_file)"
        grep -Fq -- "$inhalt_entry" "$project_root/INHALT.md" \
            || fail "$relative_file: Titel fehlt im Dokumentindex oder weicht ab (erwartet: $inhalt_entry)"
    fi

    case "$status" in
        draft|active|deprecated|superseded|retired) ;;
        '') fail "$relative_file enthält keinen status" ;;
        *) fail "$relative_file hat den ungültigen Status '$status'" ;;
    esac

    if [[ "$status" == "superseded" ]]; then
        if [[ -z "$superseded_by" ]]; then
            fail "$relative_file hat den Status superseded, enthält aber kein superseded_by"
        else
            printf '%s|%s|%s\n' "$rule_id" "$superseded_by" "$relative_file" >> "$superseded_rules"
        fi
    elif [[ -n "$superseded_by" ]]; then
        fail "$relative_file darf superseded_by nur mit dem Status superseded verwenden"
    fi

    case "$priority" in
        mandatory)
            required_heading='Verbindliches Verhalten'
            prohibited_heading='Verbotenes Verhalten'
            required_modal='MUSS'
            prohibited_modal='DARF NICHT'
            ;;
        recommended)
            required_heading='Empfohlenes Verhalten'
            prohibited_heading='Abgeratenes Verhalten'
            required_modal='SOLLTE'
            prohibited_modal='SOLLTE NICHT'
            ;;
        contextual)
            required_heading='Kontextabhängige Hinweise'
            prohibited_heading='Kontextabhängige Warnungen'
            required_modal='KANN'
            prohibited_modal='SOLLTE NICHT'
            ;;
        *)
            fail "$relative_file hat die ungültige Priorität '$priority'"
            continue
            ;;
    esac

    printf '%s\n' "$rule_id" >> "$rule_ids"

    [[ "$(count_bullets "$required_heading" "$rule_file")" -ge 1 ]] || fail "$relative_file: Abschnitt '$required_heading' enthält keine Regelpunkte"
    [[ "$(count_bullets "$prohibited_heading" "$rule_file")" -ge 1 ]] || fail "$relative_file: Abschnitt '$prohibited_heading' enthält keine Regelpunkte"
    [[ "$(count_bullets Quellen "$rule_file")" -ge 1 ]] || fail "$relative_file: Abschnitt 'Quellen' enthält keine Quellenangaben"

    for section in Absicht Regel "$required_heading" "$prohibited_heading" Entscheidungskriterien Prüfung Quellen; do
        grep -q "^## $section$" "$rule_file" || fail "$relative_file enthält den Abschnitt '$section' nicht"
    done

    rule_statement="$(awk '/^## Regel$/{getline; while ($0 == "") getline; print; exit}' "$rule_file")"
    case "$priority" in
        mandatory)
            [[ "$rule_statement" == *MUSS* || "$rule_statement" == *'DARF NICHT'* ]] || fail "$relative_file muss im Regelsatz MUSS oder DARF NICHT verwenden"
            ;;
        recommended)
            [[ "$rule_statement" == *SOLLTE* ]] || fail "$relative_file muss im Regelsatz SOLLTE oder SOLLTE NICHT verwenden"
            ;;
        contextual)
            [[ "$rule_statement" == *KANN* ]] || fail "$relative_file muss im Regelsatz KANN verwenden"
            ;;
    esac

    if ! awk -v required_heading="$required_heading" \
             -v prohibited_heading="$prohibited_heading" \
             -v required_modal="$required_modal" \
             -v prohibited_modal="$prohibited_modal" '
        $0 == "## " required_heading { mode = "required"; next }
        $0 == "## " prohibited_heading { mode = "prohibited"; next }
        /^## / { mode = "" }
        mode == "required" && /^- / {
            if (index($0, "- " required_modal " ") != 1 || index($0, "- " prohibited_modal " ") == 1) {
                print FNR ": " $0
                invalid = 1
            }
        }
        mode == "prohibited" && /^- / {
            if (index($0, "- " prohibited_modal " ") != 1) {
                print FNR ": " $0
                invalid = 1
            }
        }
        END { exit invalid }
    ' "$rule_file" > "$validation_tmp/modal-errors"; then
        while IFS= read -r error; do
            fail "$relative_file:$error hat ein Modalwort, das nicht zur Priorität '$priority' passt"
        done < "$validation_tmp/modal-errors"
    fi

    if ! awk '
        /^## Quellen$/ { in_sources = 1; next }
        /^## / { in_sources = 0 }
        in_sources && /^- / && $0 !~ /^- \[[A-Z0-9-]+\]\(\.\.\/sources\/references\.md#[a-z0-9-]+\)$/ {
            print FNR ": " $0
            invalid = 1
        }
        END { exit invalid }
    ' "$rule_file" > "$validation_tmp/source-errors"; then
        while IFS= read -r error; do
            fail "$relative_file:$error muss eine Referenz-ID aus sources/references.md verwenden"
        done < "$validation_tmp/source-errors"
    fi
done

duplicate_ids="$(sort "$rule_ids" | uniq -d)"
[[ -z "$duplicate_ids" ]] || fail "doppelte Regel-IDs: $duplicate_ids"

while IFS='|' read -r superseded_id replacement_id superseded_file; do
    [[ -n "$superseded_id" ]] || continue
    [[ "$superseded_id" != "$replacement_id" ]] || fail "$superseded_file darf sich nicht selbst als Nachfolger angeben"
    grep -Fxq "$replacement_id" "$rule_ids" || fail "$superseded_file verweist mit superseded_by auf die unbekannte Regel-ID '$replacement_id'"
done < "$superseded_rules"

while IFS= read -r source_line; do
    source_id="$(printf '%s\n' "$source_line" | sed -n 's/^- \[\([A-Z0-9-]*\)\].*/\1/p')"
    source_anchor="$(printf '%s\n' "$source_line" | sed -n 's/.*references\.md#\([a-z0-9-]*\)).*/\1/p')"
    [[ -n "$source_id" ]] || continue
    expected_anchor="$(printf '%s' "$source_id" | tr '[:upper:]' '[:lower:]')"
    [[ "$source_anchor" == "$expected_anchor" ]] || fail "Quelle $source_id verweist auf den unerwarteten Anker '$source_anchor'"
    grep -q "^### $source_id$" "$project_root/sources/references.md" || fail "Quelle $source_id fehlt in sources/references.md"
done < <(sed -sn '/^## Quellen$/,/^## /{/^- \[/p;}' "$project_root"/rules/*.md)

if ! grep -qE '^[-] .+\]\(https://[^)]+\)$' "$project_root/sources/references.md"; then
    fail "sources/references.md muss direkte HTTPS-Links enthalten"
fi

if ((failures > 0)); then
    printf '\nValidierung mit %d Fehler(n) fehlgeschlagen.\n' "$failures" >&2
    exit 1
fi

printf 'Validierung erfolgreich: %d Regeln, gültige Lebenszyklusstatus, eindeutige IDs, konsistente Modalwörter und gültige Quellen-IDs.\n' "$(wc -l < "$rule_ids")"
