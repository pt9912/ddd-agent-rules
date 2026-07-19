#!/usr/bin/env bash
#
# init-fixture.sh — richtet in einem Zielverzeichnis ein Ziel-Repo ein, in dem
# das DDD-Regelwerk gegen ein fiktives Projekt getestet werden kann.
#
# Es folgt exakt der dokumentierten Installation (README / AGENTS.target.md):
#   1. AGENTS.target.md  ->  <ziel>/AGENTS.md
#   2. rules/ + checklists/ (+ ergaenzende Hilfen) unter denselben Pfaden
#   3. Das fiktive Projekt aus evals/fixture/ darueberlegen
#
# Aufruf:
#   evals/init-fixture.sh <ZIELVERZEICHNIS> [OPTIONEN]
#
# Optionen:
#   --force     ein vorhandenes, nicht leeres Zielverzeichnis ueberschreiben
#   --no-git    kein "git init" im Zielverzeichnis
#   -h|--help   diese Hilfe anzeigen

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
fixture_dir="$script_dir/fixture"

usage() {
    awk 'NR>=3 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"
}

force=0
do_git=1
target=""

while (($#)); do
    case "$1" in
        --force) force=1 ;;
        --no-git) do_git=0 ;;
        -h|--help) usage; exit 0 ;;
        --) shift; break ;;
        -*) printf 'FEHLER: unbekannte Option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
        *)
            if [[ -n "$target" ]]; then
                printf 'FEHLER: nur ein Zielverzeichnis erlaubt (bekam auch "%s").\n' "$1" >&2
                exit 2
            fi
            target="$1"
            ;;
    esac
    shift
done
[[ -n "${1:-}" && -z "$target" ]] && target="$1"

if [[ -z "$target" ]]; then
    printf 'FEHLER: Zielverzeichnis fehlt.\n\n' >&2
    usage >&2
    exit 2
fi

if [[ -e "$target" && -n "$(ls -A "$target" 2>/dev/null)" && "$force" -ne 1 ]]; then
    printf 'FEHLER: %s ist nicht leer. Mit --force ueberschreiben.\n' "$target" >&2
    exit 1
fi
mkdir -p "$target"
target="$(cd "$target" && pwd)"

# Bestandteile des Regelwerks, die in ein Ziel-Repo gehoeren.
ruleset_dirs=(rules checklists decisions patterns anti-patterns examples sources)

# 1. AGENTS.target.md wird im Ziel-Repo zu AGENTS.md.
cp "$repo_root/AGENTS.target.md" "$target/AGENTS.md"

# 2. Regelwerk unter denselben relativen Pfaden bereitstellen.
for d in "${ruleset_dirs[@]}"; do
    if [[ -d "$repo_root/$d" ]]; then
        mkdir -p "$target/$d"
        cp -R "$repo_root/$d/." "$target/$d/"
    fi
done

# 3. Fiktives Projekt darueberlegen.
if [[ -d "$fixture_dir" ]]; then
    cp -R "$fixture_dir/." "$target/"
fi

# Optional: git-Repo initialisieren.
if [[ "$do_git" -eq 1 ]] && command -v git >/dev/null 2>&1; then
    git -C "$target" init -q
    git -C "$target" add -A
    git -C "$target" \
        -c user.name=ddd-eval -c user.email=eval@example.invalid \
        commit -q -m "Fixture-Repo aus DDD-Regelwerk aufgesetzt" || true
fi

printf 'Fixture-Repo aufgesetzt: %s\n' "$target"
printf '  AGENTS.md + %s\n' "${ruleset_dirs[*]}"
printf '  Fiktives Projekt: domain/, src/, BUILD.md\n'
printf '\nSzenarien (Pruefmassstab, NICHT im Ziel-Repo): %s/scenarios/\n' "$script_dir"
printf 'Naechster Schritt: einen Code-Agenten mit Arbeitsverzeichnis\n'
printf '  %s\n' "$target"
printf 'starten, ihm die "Aufgabe" eines Szenarios geben und die Antwort gegen\n'
printf 'dessen Akzeptanzkriterien graden.\n'
