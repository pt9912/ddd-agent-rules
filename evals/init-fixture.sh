#!/usr/bin/env bash
#
# init-fixture.sh — richtet in einem Zielverzeichnis ein Ziel-Repo ein, in dem
# das DDD-Regelwerk gegen ein fiktives Projekt getestet werden kann.
#
# Ablauf:
#   1. Das Regelwerk (AGENTS.md + rules/ + checklists/, dokumentierter
#      Mindestumfang) gebuendelt unter <ziel>/.ddd-harness/ ablegen; die
#      relative Struktur bleibt erhalten, damit alle internen Verweise gelten.
#   2. Eine schlanke <ziel>/AGENTS.md an der Wurzel auf .ddd-harness/AGENTS.md
#      verweisen lassen.
#   3. Das fiktive Projekt aus evals/fixture/ an die Wurzel legen.
#
# Aufruf:
#   evals/init-fixture.sh <ZIELVERZEICHNIS> [OPTIONEN]
#
# Optionen:
#   --with-hilfen  zusaetzlich decisions/ patterns/ anti-patterns/ examples/
#                  sources/ bereitstellen (ergaenzende, optionale Hilfen)
#   --with-verify  den Zielrepo-Verifikations-Helfer (templates/ddd-verify) und
#                  einen Beispiel-Invariantentest (ddd-invariants/) beilegen
#   --force        ein vorhandenes, nicht leeres Zielverzeichnis ueberschreiben
#   --no-git       kein "git init" im Zielverzeichnis
#   -h|--help      diese Hilfe anzeigen

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
fixture_dir="$script_dir/fixture"
harness_dir="${DDD_HARNESS_DIR:-.ddd-harness}"

usage() {
    awk 'NR>=3 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"
}

force=0
do_git=1
with_hilfen=0
with_verify=0
target=""

while (($#)); do
    case "$1" in
        --with-hilfen) with_hilfen=1 ;;
        --with-verify) with_verify=1 ;;
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

# Dokumentierter Mindestumfang; die Hilfen sind optional (--with-hilfen).
ruleset_dirs=(rules checklists)
if [[ "$with_hilfen" -eq 1 ]]; then
    ruleset_dirs+=(decisions patterns anti-patterns examples sources)
fi

# 1. Regelwerk gebuendelt unter .ddd-harness/ ablegen. AGENTS.target.md und die
#    Regeldateien behalten ihre relative Struktur, damit alle internen Verweise
#    (../sources/..., ../../rules/...) gueltig bleiben.
harness_path="$target/$harness_dir"
mkdir -p "$harness_path"
cp "$repo_root/AGENTS.target.md" "$harness_path/AGENTS.md"
for d in "${ruleset_dirs[@]}"; do
    if [[ -d "$repo_root/$d" ]]; then
        mkdir -p "$harness_path/$d"
        cp -R "$repo_root/$d/." "$harness_path/$d/"
    fi
done

# 2. Schlanke Wurzel-AGENTS.md, die auf das gebuendelte Regelwerk verweist.
cat > "$target/AGENTS.md" <<EOF
# Agentenanweisungen

Die verbindlichen DDD-Arbeitsanweisungen fuer dieses Repository stehen in
[$harness_dir/AGENTS.md]($harness_dir/AGENTS.md). Lies sie zuerst und wende sie an.

Das zugehoerige Regelwerk (Regeln, Prueflisten und optionale Hilfen) liegt unter
\`$harness_dir/\`.
EOF

# 3. Fiktives Projekt an die Wurzel legen.
if [[ -d "$fixture_dir" ]]; then
    cp -R "$fixture_dir/." "$target/"
fi

# 4. Optional: den eigenstaendigen Zielrepo-Verifikations-Helfer beilegen.
if [[ "$with_verify" -eq 1 && -d "$repo_root/templates/ddd-verify" ]]; then
    mkdir -p "$target/ddd-verify"
    cp -R "$repo_root/templates/ddd-verify/." "$target/ddd-verify/"
    if [[ -d "$target/ddd-verify/beispiel" ]]; then
        mkdir -p "$target/ddd-invariants"
        cp "$target/ddd-verify/beispiel/"*.java "$target/ddd-invariants/" 2>/dev/null || true
    fi
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
printf '  Wurzel: AGENTS.md (Verweis) + fiktives Projekt (domain/, src/, BUILD.md)\n'
printf '  %s/: AGENTS.md + %s\n' "$harness_dir" "${ruleset_dirs[*]}"
if [[ "$with_verify" -eq 1 ]]; then
    printf '  ddd-verify/ + ddd-invariants/ (Zielrepo-Invariantenverifikation)\n'
fi
printf '\nSzenarien (Pruefmassstab, NICHT im Ziel-Repo): %s/scenarios/\n' "$script_dir"
printf 'Naechster Schritt: einen Code-Agenten mit Arbeitsverzeichnis\n'
printf '  %s\n' "$target"
printf 'starten, ihm die "Aufgabe" eines Szenarios geben und die Antwort gegen\n'
printf 'dessen Akzeptanzkriterien graden.\n'
