# Domänenereignis oder Integrationsereignis?

Verwende ein Domänenereignis, wenn:

- die Tatsache innerhalb eines Bounded Contexts bedeutsam ist
- Handler mit dem lokalen Modell arbeiten
- das Ereignis lokale Domänensemantik enthalten darf

Verwende ein Integrationsereignis, wenn:

- die Tatsache die Grenze eines Bounded Contexts oder Dienstes überschreitet
- der Vertrag für externe Empfänger stabil bleiben muss
- die Nutzlast keine internen Domänentypen offenlegen darf
- Empfänger nur bestätigte fachliche Änderungen beobachten dürfen

Übersetze Domänenereignisse bewusst in Integrationsereignisse.
Wenn zuverlässige Zustellung erforderlich ist, persistiere die ausgehende Integrationsnachricht atomar mit der fachlichen Änderung und veröffentliche sie nach dem Commit. Empfänger müssen Wiederholungen und doppelte Zustellung tolerieren.

## Maßgebliche Regeln

- [DDD-EVT-001](../rules/11-domain-events.md)
- [DDD-INT-001](../rules/14-context-integration.md)
