# Muster: Repository

## Zweck

Lade und persistiere Aggregatwurzeln, ohne Persistenzdetails offenzulegen.

## Hinweise

- bei Bedarf ein Repository je persistierter Aggregatwurzel
- domänenorientierte Operationen
- Implementierung in der Infrastruktur
- getrennte Lesemodelle für komplexe Abfragen

Vermeide generische CRUD-Repositories als Standardentwurf.

## Maßgebliche Regeln

- [DDD-AGG-001](../rules/08-aggregates.md)
- [DDD-REP-001](../rules/10-repositories.md)
