# Muster: Transaktionale Outbox

## Zweck

Veröffentliche Integrationsnachrichten nach Änderungen des Domänenzustands zuverlässig.

## Hinweise

- ausgehende Nachricht atomar mit der fachlichen Transaktion speichern
- erst nach dem Commit der fachlichen Transaktion asynchron veröffentlichen
- Zustellstatus kennzeichnen
- Empfänger idempotent gestalten
- Wiederholungs- und Reihenfolgesemantik ausdrücklich definieren

Verwende eine Outbox, wenn eine bestätigte fachliche Änderung und die zuverlässige kontextübergreifende Nachrichtenzustellung nicht auseinanderfallen dürfen. Die Outbox ist ein Infrastrukturmuster und kein Teil des Domänenmodells.

## Maßgebliche Regeln

- [DDD-EVT-001](../rules/11-domain-events.md)
- [DDD-INF-001](../rules/13-infrastructure-layer.md)
- [DDD-INT-001](../rules/14-context-integration.md)
