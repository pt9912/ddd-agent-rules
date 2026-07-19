#!/usr/bin/env bash
#
# docker-verify.sh — läuft IM Container (evals/Dockerfile). Kompiliert die
# lager-Quellen des nach /repo gemounteten Ziel-Repos zusammen mit dem
# versteckten Referenztest zu Szenario $1 (aus /opt/eval/verify/$1/) und führt
# ihn aus. Objektives PASS/FAIL, unabhängig von jeder Modell-Meinung. Der
# Referenztest steckt im Image, nie im Ziel-Repo — der Agent kann ihn nicht sehen.
#
# Exit: 0 = PASS, 1 = FAIL (Kompilierung oder Assertions), 2 = Nutzungsfehler.

set -euo pipefail

scenario="${1:?Szenario-ID erwartet (z. B. 003)}"
refdir="/opt/eval/verify/$scenario"
srcdir="/repo/src/main/java"

[[ -d "$refdir" ]] || { printf 'FEHLER: kein Referenztest für Szenario %s\n' "$scenario" >&2; exit 2; }
[[ -d "$srcdir" ]] || { printf 'FEHLER: %s fehlt (Ziel-Repo nach /repo gemountet?)\n' "$srcdir" >&2; exit 2; }

tmp="$(mktemp -d)"
find "$srcdir" -name '*.java' > "$tmp/sources.txt"
find "$refdir" -name '*.java' >> "$tmp/sources.txt"

if ! javac -d "$tmp/classes" @"$tmp/sources.txt" 2> "$tmp/javac.err"; then
    printf '=> FAIL (Kompilierung fehlgeschlagen; fehlt die geforderte Methode?)\n'
    sed 's/^/  /' "$tmp/javac.err" >&2
    exit 1
fi

ref="$(find "$refdir" -name '*.java' | head -1)"
pkg="$(sed -n 's/^package \([A-Za-z0-9_.]*\);.*/\1/p' "$ref" | head -1)"
cname="$(sed -n 's/.*public class \([A-Za-z0-9_]*\).*/\1/p' "$ref" | head -1)"
cls="${pkg:+$pkg.}$cname"

if java -cp "$tmp/classes" "$cls"; then
    printf '=> PASS\n'
else
    printf '=> FAIL (Assertions/Laufzeit)\n'
    exit 1
fi
