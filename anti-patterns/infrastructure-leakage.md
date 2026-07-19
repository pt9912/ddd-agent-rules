# Antimuster: Infrastrukturleck

## Symptome

- ORM- oder Transporttypen erscheinen in Domänen-APIs
- Domänentests benötigen eine Datenbank
- fachliche Regeln hängen von Framework-Callbacks ab
- externe Schemas geben Domänennamen vor

## Korrektur

Führe Ports, Mapper und Adapter ein. Halte Domänenverhalten unabhängig von Frameworks.

## Maßgebliche Regeln

- [DDD-MOD-001](../rules/03-domain-modeling.md)
- [DDD-INF-001](../rules/13-infrastructure-layer.md)
