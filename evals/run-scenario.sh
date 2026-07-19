#!/usr/bin/env bash
#
# run-scenario.sh — setzt aus einer Prompt-Vorlage, dem Auftrag eines Szenarios
# und einem Zielpfad den fertigen Agenten-Prompt zusammen und gibt ihn auf
# stdout aus. So ist ein Eval-Lauf reproduzierbar: Auftrag aus dem Szenario,
# Wrapper aus evals/prompts/.
#
# Aufruf:
#   evals/run-scenario.sh <szenario.md> <repo-pfad> <ausgabe-pfad> [OPTIONEN]
#
# Optionen:
#   --ohne-regelwerk  Vorlage prompts/runner-ohne-regelwerk.md verwenden
#                     (Ablationsarm); Standard ist runner-mit-regelwerk.md
#   -h|--help         diese Hilfe anzeigen
#
# Platzhalter in den Vorlagen: {{repo}} {{aufgabe}} {{ausgabe}}
# Der Auftrag stammt aus dem "## Aufgabe"-Blockzitat des Szenarios.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    awk 'NR>=3 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"
}

template="$script_dir/prompts/runner-mit-regelwerk.md"
positional=()

while (($#)); do
    case "$1" in
        --ohne-regelwerk) template="$script_dir/prompts/runner-ohne-regelwerk.md" ;;
        --mit-regelwerk) template="$script_dir/prompts/runner-mit-regelwerk.md" ;;
        -h|--help) usage; exit 0 ;;
        --) shift; break ;;
        -*) printf 'FEHLER: unbekannte Option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
        *) positional+=("$1") ;;
    esac
    shift
done
while (($#)); do positional+=("$1"); shift; done

if ((${#positional[@]} != 3)); then
    printf 'FEHLER: erwarte <szenario.md> <repo-pfad> <ausgabe-pfad>.\n\n' >&2
    usage >&2
    exit 2
fi
scenario="${positional[0]}"
repo="${positional[1]}"
ausgabe="${positional[2]}"

[[ -f "$scenario" ]] || { printf 'FEHLER: Szenario nicht gefunden: %s\n' "$scenario" >&2; exit 2; }
[[ -f "$template" ]] || { printf 'FEHLER: Vorlage nicht gefunden: %s\n' "$template" >&2; exit 2; }

# Auftrag aus dem "## Aufgabe"-Blockzitat extrahieren ("> " entfernt).
aufgabe="$(awk '
    /^## Aufgabe/ { inblock = 1; next }
    inblock && /^## / { exit }
    inblock && /^>/ { sub(/^> ?/, ""); print }
' "$scenario")"
[[ -n "$aufgabe" ]] || { printf 'FEHLER: kein "## Aufgabe"-Blockzitat in %s\n' "$scenario" >&2; exit 2; }

# Vorlage fuellen (literale Ersetzung via bash-Parameterexpansion).
prompt="$(cat "$template")"
prompt="${prompt//'{{repo}}'/$repo}"
prompt="${prompt//'{{ausgabe}}'/$ausgabe}"
prompt="${prompt//'{{aufgabe}}'/$aufgabe}"
printf '%s\n' "$prompt"
