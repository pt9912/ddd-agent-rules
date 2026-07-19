#!/usr/bin/env bash
#
# grade.sh — bewertet Agenten-Antworten gegen die Akzeptanzkriterien eines
# Szenarios (Signal-Assert; halb-deterministisch).
#
# Aufruf:
#   evals/grade.sh <szenario.md> <agent-antwort> [weitere-antworten ...]
#
# Liest den ```grading-Block des Szenarios:
#   bereitschaft: <erlaubte Werte, leerzeichengetrennt>
#   pflicht:      <Signal>            (wiederholbar; ALLE muessen vorkommen)
#   pflicht-any:  <Signal> <Signal>   (wiederholbar; je Zeile MIND. EINES)
#   verboten:     <Signal>            (wiederholbar; KEINES darf vorkommen)
#
# Pro Antwortdatei PASS, wenn alle Pflicht-Signale vorkommen, kein verbotenes
# vorkommt und (falls angegeben) eine erlaubte Bereitschaft genannt ist. Am Ende
# die Pass-Rate; Exit 0 nur, wenn alle Antworten bestehen.
#
# Hinweis: Signal-Assert ist eine grobe, formulierungsabhaengige Heuristik.
# Fuer Readiness- und Ueber-Anwendungs-Szenarien ergaenzt ein LLM-Judge.

set -euo pipefail

if (($# < 2)); then
    awk 'NR>=3 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}" >&2
    exit 2
fi

scenario="$1"
shift
[[ -f "$scenario" ]] || { printf 'FEHLER: Szenario nicht gefunden: %s\n' "$scenario" >&2; exit 2; }

block="$(awk '/^```grading$/{f=1;next} f&&/^```/{f=0} f' "$scenario")"
[[ -n "$block" ]] || { printf 'FEHLER: kein ```grading-Block in %s\n' "$scenario" >&2; exit 2; }

bereitschaft="$(printf '%s\n' "$block" | sed -n 's/^bereitschaft:[[:space:]]*//p')"
mapfile -t pflicht < <(printf '%s\n' "$block" | sed -n 's/^pflicht:[[:space:]]*//p')
mapfile -t pflicht_any < <(printf '%s\n' "$block" | sed -n 's/^pflicht-any:[[:space:]]*//p')
mapfile -t verboten < <(printf '%s\n' "$block" | sed -n 's/^verboten:[[:space:]]*//p')

pass_count=0
total=0

for out in "$@"; do
    total=$((total + 1))
    printf '── %s\n' "$out"
    if [[ ! -f "$out" ]]; then
        printf '  FEHLER: Datei fehlt\n  => FAIL\n'
        continue
    fi
    ok=1

    for sig in "${pflicht[@]:-}"; do
        [[ -n "$sig" ]] || continue
        if grep -Fqi -- "$sig" "$out"; then
            printf '  pflicht  OK    %s\n' "$sig"
        else
            printf '  pflicht  FEHLT %s\n' "$sig"; ok=0
        fi
    done

    # pflicht-any: je Gruppe muss MINDESTENS EIN Alternativ-Signal vorkommen.
    for grp in "${pflicht_any[@]:-}"; do
        [[ -n "$grp" ]] || continue
        hit=""
        for alt in $grp; do
            if grep -Fqi -- "$alt" "$out"; then hit="$alt"; break; fi
        done
        if [[ -n "$hit" ]]; then
            printf '  pflicht-any OK (%s via %s)\n' "$grp" "$hit"
        else
            printf '  pflicht-any FEHLT (eines von: %s)\n' "$grp"; ok=0
        fi
    done

    for sig in "${verboten[@]:-}"; do
        [[ -n "$sig" ]] || continue
        if grep -Fqi -- "$sig" "$out"; then
            printf '  verboten TRIFFT %s\n' "$sig"; ok=0
        else
            printf '  verboten OK     %s\n' "$sig"
        fi
    done

    # Bereitschaft aus der Deklarationszeile lesen (nicht dem ganzen Dokument),
    # damit die blosse Erwaehnung der Stufen-Skala nicht faelschlich matcht.
    if [[ -n "$bereitschaft" ]]; then
        decl="$(grep -iE 'bereitschaft' "$out" || true)"
        haystack="${decl:-$(cat "$out")}"
        found=0
        for tok in $bereitschaft; do
            if grep -Fqi -- "$tok" <<<"$haystack"; then found=1; hit="$tok"; break; fi
        done
        if [[ $found -eq 1 ]]; then
            printf '  bereitsch OK   %s\n' "$hit"
        else
            printf '  bereitsch FEHLT (erwartet: %s)\n' "$bereitschaft"; ok=0
        fi
    fi

    if [[ $ok -eq 1 ]]; then
        printf '  => PASS\n'; pass_count=$((pass_count + 1))
    else
        printf '  => FAIL\n'
    fi
done

printf '\nErgebnis: %d/%d bestanden\n' "$pass_count" "$total"
[[ "$pass_count" -eq "$total" ]]
