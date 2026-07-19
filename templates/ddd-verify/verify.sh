#!/usr/bin/env bash
#
# verify.sh — läuft IM Container. Kompiliert die Java-Quellen des nach /repo
# gemounteten Ziel-Repos (src/main/java) zusammen mit den Invariantentests unter
# /repo/ddd-invariants und führt jede Testklasse (public static void main) aus.
#
# Exit: 0 = alle PASS, 1 = FAIL, 2 = Nutzungsfehler.

set -euo pipefail

src="/repo/src/main/java"
inv="/repo/ddd-invariants"

[[ -d "$src" ]] || { printf 'FEHLER: %s fehlt\n' "$src" >&2; exit 2; }
[[ -d "$inv" ]] || { printf 'FEHLER: %s fehlt — Invariantentests hier ablegen\n' "$inv" >&2; exit 2; }

tmp="$(mktemp -d)"
find "$src" "$inv" -name '*.java' > "$tmp/sources.txt"

if ! javac -d "$tmp/classes" @"$tmp/sources.txt" 2> "$tmp/err"; then
    printf '=> FAIL (Kompilierung)\n'
    sed 's/^/  /' "$tmp/err" >&2
    exit 1
fi

fail=0
found=0
while IFS= read -r f; do
    grep -q 'static void main' "$f" || continue
    found=1
    pkg="$(sed -n 's/^package \([A-Za-z0-9_.]*\);.*/\1/p' "$f" | head -1)"
    cn="$(basename "$f" .java)"
    cls="${pkg:+$pkg.}$cn"
    printf '── %s\n' "$cls"
    if java -cp "$tmp/classes" "$cls"; then
        printf '  PASS\n'
    else
        printf '  FAIL\n'
        fail=1
    fi
done < <(find "$inv" -name '*.java')

((found == 1)) || { printf 'FEHLER: keine Invariantentests (public static void main) in %s\n' "$inv" >&2; exit 2; }

if ((fail == 0)); then
    printf '=> PASS\n'
else
    printf '=> FAIL\n'
    exit 1
fi
