# Entität oder Wertobjekt?

Verwende eine Entität, wenn:

- die Identität fachlich bedeutsam ist
- das Objekt einen Lebenszyklus hat
- zwei Objekte mit gleichen Attributen dennoch verschiedene Dinge sein können

Verwende ein Wertobjekt, wenn:

- Werte das Konzept vollständig beschreiben
- der Austausch gegen eine gleiche Instanz folgenlos ist
- Unveränderlichkeit natürlich ist
- das Konzept fachliche Bedeutung validiert oder berechnet

Bevorzuge ein Wertobjekt, bis die Notwendigkeit einer Identität nachgewiesen ist.

## Maßgebliche Regeln

- [DDD-ENT-001](../rules/06-entities.md)
- [DDD-VO-001](../rules/07-value-objects.md)
