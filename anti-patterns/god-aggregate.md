# Antimuster: Gott-Aggregat

## Symptome

- viele nicht zusammengehörige Entitäten werden gemeinsam geladen
- häufige Nebenläufigkeitskonflikte
- große Transaktionen
- langsame Persistenz
- nicht zusammengehörige Lebenszyklusänderungen blockieren einander

## Korrektur

Bestimme die tatsächliche Invariante und trenne unabhängige Konsistenzgrenzen.

## Maßgebliche Regeln

- [DDD-AGG-001](../rules/08-aggregates.md)
