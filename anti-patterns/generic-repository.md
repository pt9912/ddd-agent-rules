# Antimuster: Generisches Repository

## Symptome

- jede Entität erhält dieselbe CRUD-Schnittstelle
- Domänenabfragen legen ORM-Ausdrücke offen
- Aggregatgrenzen verschwinden
- untergeordnete Entitäten werden unabhängig aktualisiert

## Korrektur

Verwende Repositories um Aggregatwurzeln und dedizierte Lesemodelle für Abfragen.

## Maßgebliche Regeln

- [DDD-AGG-001](../rules/08-aggregates.md)
- [DDD-REP-001](../rules/10-repositories.md)
