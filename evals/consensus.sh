#!/usr/bin/env bash
#
# consensus.sh — führt die Verifikations-Ebenen zu einem Verdikt zusammen
# (Triangulation): ausführbarer Test (maßgeblich), adversariales Judge-Panel
# (Mehrheit) und Signal-Assert (Kreuzprüfung).
#
# Aufruf:
#   consensus.sh [--exec PASS|FAIL] [--signal PASS|FAIL] --judge V [--judge V ...]
#
# Logik:
#   - Panel  = Mehrheit der --judge-Stimmen (Gleichstand => FAIL, markiert).
#   - Final  = --exec, falls vorhanden (objektiv, maßgeblich); sonst Panel.
#   - Konfidenz HOCH, wenn alle vorhandenen Ebenen übereinstimmen; sonst
#     PRÜFEN (menschliche Sichtung) mit Auflistung der abweichenden Ebenen.
#
# Exit: 0 = Final PASS (Konfidenz hoch), 1 = Final FAIL (Konfidenz hoch),
#       3 = Divergenz zwischen Ebenen (menschliche Sichtung nötig), 2 = Nutzung.

set -euo pipefail

usage() { awk 'NR>=3 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"; }

norm() {
    case "${1^^}" in
        PASS) printf 'PASS' ;;
        FAIL) printf 'FAIL' ;;
        *) printf 'FEHLER: Wert muss PASS oder FAIL sein: %s\n' "$1" >&2; exit 2 ;;
    esac
}

exec_v=""
signal_v=""
judges=()

while (($#)); do
    case "$1" in
        --exec) exec_v="$(norm "${2:?}")"; shift 2 ;;
        --signal) signal_v="$(norm "${2:?}")"; shift 2 ;;
        --judge) judges+=("$(norm "${2:?}")"); shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'FEHLER: unbekanntes Argument: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
done

if ((${#judges[@]} == 0)) && [[ -z "$exec_v" ]]; then
    printf 'FEHLER: mindestens --exec oder ein --judge nötig.\n\n' >&2
    usage >&2
    exit 2
fi

# Panel-Mehrheit
panel=""
tie=0
if ((${#judges[@]} > 0)); then
    p=0; f=0
    for v in "${judges[@]}"; do
        [[ "$v" == PASS ]] && p=$((p + 1)) || f=$((f + 1))
    done
    if ((p > f)); then panel=PASS
    elif ((f > p)); then panel=FAIL
    else panel=FAIL; tie=1
    fi
fi

# Finalurteil: ausführbarer Test ist maßgeblich, sonst Panel.
if [[ -n "$exec_v" ]]; then final="$exec_v"; else final="$panel"; fi

# Vorhandene Ebenen einsammeln und auf Übereinstimmung prüfen.
declare -a labels vals
[[ -n "$exec_v" ]]   && { labels+=("ausführbar"); vals+=("$exec_v"); }
[[ -n "$panel" ]]    && { labels+=("panel($p/$((p+f)))"); vals+=("$panel"); }
[[ -n "$signal_v" ]] && { labels+=("signal"); vals+=("$signal_v"); }

uniq="$(printf '%s\n' "${vals[@]}" | sort -u | wc -l)"
divergenz=0
((uniq > 1)) && divergenz=1

printf 'Ebenen:'
for i in "${!labels[@]}"; do printf ' %s=%s' "${labels[$i]}" "${vals[$i]}"; done
printf '\n'
((tie == 1)) && printf 'Hinweis: Judge-Panel im Gleichstand -> konservativ FAIL.\n'

printf 'Finalurteil: %s\n' "$final"
if ((divergenz == 1)); then
    printf 'Konfidenz: PRÜFEN — die Ebenen weichen voneinander ab (menschliche Sichtung nötig).\n'
    exit 3
fi
printf 'Konfidenz: HOCH — alle Ebenen stimmen überein.\n'
[[ "$final" == PASS ]]
