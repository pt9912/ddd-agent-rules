# Antimuster: Anämisches Domänenmodell

## Symptome

- Entitäten enthalten nur Felder und Setter
- Dienste besitzen alle fachlichen Entscheidungen
- ungültige Zustände lassen sich leicht erzeugen
- Zustandsübergänge sind dupliziert

## Korrektur

Verschiebe Verhalten und Invariantenprüfungen in die Domänenobjekte, die den Zustand besitzen.

## Maßgebliche Regeln

- [DDD-MOD-001](../rules/03-domain-modeling.md)
- [DDD-AGG-001](../rules/08-aggregates.md)
