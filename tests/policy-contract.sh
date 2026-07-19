#!/usr/bin/env bash

set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

assert_contains() {
    local file="$1"
    local expected="$2"
    if ! grep -Fq -- "$expected" "$project_root/$file"; then
        printf 'FEHLER: %s muss enthalten: %s\n' "$file" "$expected" >&2
        failures=$((failures + 1))
    fi
}

assert_absent() {
    local file="$1"
    local rejected="$2"
    if grep -Fq -- "$rejected" "$project_root/$file"; then
        printf 'FEHLER: %s darf nicht enthalten: %s\n' "$file" "$rejected" >&2
        failures=$((failures + 1))
    fi
}

assert_before() {
    local file="$1"
    local first="$2"
    local second="$3"
    local first_line
    local second_line

    first_line="$(grep -nF -m1 -- "$first" "$project_root/$file" | cut -d: -f1 || true)"
    second_line="$(grep -nF -m1 -- "$second" "$project_root/$file" | cut -d: -f1 || true)"
    if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
        printf 'FEHLER: In %s muss %s vor %s stehen.\n' "$file" "$first" "$second" >&2
        failures=$((failures + 1))
    fi
}

assert_contains rules/11-domain-events.md 'SOLLTE NICHT ein Integrationsereignis vor dem Commit der auslösenden Transaktion veröffentlichen.'
assert_contains rules/11-domain-events.md 'SOLLTE eine ausgehende Integrationsnachricht atomar mit dem fachlichen Zustand persistieren'
assert_contains rules/12-application-layer.md 'DARF NICHT zustandsabhängige fachliche Autorisierung ausschließlich in einem Anwendungs-Handler belassen.'
assert_contains rules/12-application-layer.md 'MUSS Integrationsnachrichten erst nach dem Commit veröffentlichen'
assert_contains rules/15-testing.md 'Bei einer reinen Prüfaufgabe MUSS der Agent fehlende und erforderliche Tests melden, DARF aber NICHT Dateien verändern'
assert_contains examples/good/value-object.md 'public record Preis'
assert_absent examples/good/value-object.md 'public record Money'
assert_contains examples/realistic/bestellbestaetigung/README.md 'Vertrieb persistiert Bestellung und Outbox-Eintrag atomar.'
assert_contains examples/realistic/bestellbestaetigung/domain-model.md 'Passende Bestellfreigabe erforderlich'
assert_contains examples/realistic/bestellbestaetigung/application-flow.md 'Schlägt das Speichern eines der beiden Artefakte fehl, werden beide Änderungen zurückgerollt.'
assert_contains examples/realistic/bestellbestaetigung/context-integration.md 'Das Anlegen des Lieferauftrags und das Markieren der `eventId` erfolgen atomar.'
assert_contains examples/realistic/bestellbestaetigung/tests.md 'Ein Test, der lediglich Repository und Outbox mockt, kann die Atomizität nicht nachweisen.'
assert_contains docs/projektlebenszyklus.md 'Er bestimmt nicht, ob eine einzelne DDD-Regel fachlich gültig ist.'
assert_contains rules/01-rule-lifecycle.md 'Der DDD-Regellebenszyklus ist unabhängig vom [Projektlebenszyklus]'
assert_contains rules/01-rule-lifecycle.md 'id: DDD-RLC-001'
assert_contains AGENTS.md 'Diese Datei steuert Änderungen an diesem Repository'
assert_contains AGENTS.md 'AGENTS.target.md'
assert_contains AGENTS.target.md 'Diese Datei ist die Vorlage für ein Ziel-Repository'
assert_contains AGENTS.target.md 'ready`, `conditional` oder `analysis-only`'
assert_contains rules/02-agent-readiness.md 'id: DDD-READY-001'
assert_contains rules/02-agent-readiness.md 'MUSS die Arbeit auf Analyse und Klärung begrenzen'
assert_contains checklists/agent-readiness.md 'Genau eine Bereitschaftsstufe wird als Ergebnis gewählt.'
assert_contains .d-check.yml 'modules: [links, anchors, ids, matrix, codepaths, spans, hostpaths]'
assert_contains .d-check.yml '{from: regeln, to: hilfen, allow: false}'
assert_contains .d-check.yml 'status: {forbidden: [draft, deprecated, superseded, retired]}'
assert_contains docs/referenzrichtung.md 'Beispiele → Hilfen → Regeln → Quellen'
assert_contains docs/referenzrichtung.md 'Projektsteuerung und Regeln DÜRFEN einander referenzieren'
assert_contains INHALT.md '[DDD-RLC-001 – Den Lebenszyklus von DDD-Regeln ausdrücklich steuern](rules/01-rule-lifecycle.md)'
assert_contains INHALT.md '[DDD-READY-001 – Fachliche Änderungsbereitschaft vor der Umsetzung herstellen](rules/02-agent-readiness.md)'
assert_contains INHALT.md '[DDD-REF-001 – Schrittweise zu klarerem Domänenverhalten refaktorieren](rules/16-refactoring.md)'
assert_before AGENTS.md '[rules/01-rule-lifecycle.md]' '[rules/02-agent-readiness.md]'
assert_before AGENTS.md '[rules/02-agent-readiness.md]' '[rules/03-domain-modeling.md]'
assert_before AGENTS.target.md '[rules/01-rule-lifecycle.md]' '[rules/02-agent-readiness.md]'
assert_before AGENTS.target.md '[rules/02-agent-readiness.md]' '[rules/03-domain-modeling.md]'
assert_before INHALT.md '[DDD-RLC-001' '[DDD-MOD-001'
assert_contains README.md '## Was ist ddd-agent-rules?'
assert_contains README.md '## Was kann ich heute tun?'
assert_contains README.md '## Warum ddd-agent-rules?'
assert_contains README.md '## Kerngedanke'
assert_contains README.md '## Was macht es vertrauenswürdig?'
assert_before README.md '## Was ist ddd-agent-rules?' '## Was kann ich heute tun?'
assert_before README.md '## Was kann ich heute tun?' '## Warum ddd-agent-rules?'
assert_before README.md '## Warum ddd-agent-rules?' '## Kerngedanke'
assert_before README.md '## Kerngedanke' '## Was macht es vertrauenswürdig?'

if ((failures > 0)); then
    printf '\nRichtlinienvertrag mit %d Fehler(n) fehlgeschlagen.\n' "$failures" >&2
    exit 1
fi

printf 'Richtlinienvertrag erfolgreich: Ziel-Repo-Readiness, getrennte Agentenverträge, Ereigniszustellung, Autorisierung, Prüfumfang, Wertobjektsemantik, Fallstudie, Lebenszyklen und Referenzrichtung.\n'
