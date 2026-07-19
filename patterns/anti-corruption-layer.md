# Muster: Anti-Corruption Layer

## Zweck

Schütze das lokale Modell vor einem fremden Modell.

## Verantwortlichkeiten

- Terminologie übersetzen
- Identifikatoren und Datenstrukturen abbilden
- Protokoll- und Anbieterkonzepte isolieren
- Kompatibilitätsverhalten kapseln

Verwende sie, wenn die Anpassung an das Upstream-Modell das lokale Domänenmodell beschädigen würde.

## Maßgebliche Regeln

- [DDD-BC-001](../rules/05-bounded-contexts.md)
- [DDD-INT-001](../rules/14-context-integration.md)
