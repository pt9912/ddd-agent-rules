# Muster: Domänenereignis

## Zweck

Stelle eine wichtige fachliche Tatsache dar und löse unabhängige Reaktionen aus.

## Hinweise

- Name in der Vergangenheitsform
- unveränderliche Nutzlast
- stabile Identifikatoren
- kein Infrastrukturverhalten
- klare Transaktions- und Veröffentlichungssemantik
- erst erfasst, nachdem das Aggregat den Übergang akzeptiert und seine Invarianten bewahrt hat
- an Grenzen von Bounded Contexts übersetzt statt unmittelbar offengelegt

Beispiel: `BestellungBestaetigt`.

Das Erfassen eines Domänenereignisses unterscheidet sich vom Veröffentlichen eines Integrationsereignisses. Eine externe Veröffentlichung darf eine Zustandsänderung nicht vor dem Commit ihrer Transaktion offenlegen.

## Maßgebliche Regeln

- [DDD-EVT-001](../rules/11-domain-events.md)
- [DDD-INT-001](../rules/14-context-integration.md)
