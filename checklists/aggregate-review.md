# Prüfliste für Aggregate

- [ ] Die geschützte Invariante ist schriftlich festgehalten.
- [ ] Die Wurzel ist der einzige Einstiegspunkt für Änderungen.
- [ ] Interne Sammlungen sind von außen nicht veränderbar.
- [ ] Das Aggregat ist klein genug für eine Transaktion.
- [ ] Andere Aggregate werden über Identifikatoren referenziert.
- [ ] Der Lebenszyklus untergeordneter Objekte wird von der Wurzel gesteuert.
- [ ] Das Nebenläufigkeitsverhalten ist verstanden.
- [ ] Domänenereignisse werden erst ausgegeben, nachdem die Invarianten gelten.
- [ ] Zustandsabhängige fachliche Berechtigungen werden vom Aggregat oder einer ausdrücklichen Domänenrichtlinie durchgesetzt.

## Maßgebliche Regeln

- [DDD-AGG-001](../rules/08-aggregates.md)
- [DDD-EVT-001](../rules/11-domain-events.md)
