# Antimuster: Geteiltes Domänenmodell

## Symptome

- mehrere Kontexte importieren dieselben Entitäten
- eine Änderung erfordert koordinierte Veröffentlichungen
- Begriffe tragen widersprüchliche Bedeutungen
- ein Kontext verändert die Daten eines anderen Kontexts

## Korrektur

Gib jedem Kontext sein eigenes Modell und übersetze an ausdrücklichen Grenzen.

## Maßgebliche Regeln

- [DDD-BC-001](../rules/05-bounded-contexts.md)
- [DDD-INT-001](../rules/14-context-integration.md)
