# DDD-Codeprüfliste

- [ ] Der Bounded Context ist bestimmt.
- [ ] Die Domänenterminologie entspricht der vorhandenen Sprache.
- [ ] Fachliches Verhalten ist nicht in der Infrastruktur verborgen.
- [ ] Entitäten haben eine bedeutsame Identität.
- [ ] Wertobjekte sind, soweit praktikabel, unveränderlich.
- [ ] Aggregatänderungen erfolgen über die Wurzel.
- [ ] Aggregatgrenzen sind durch Invarianten begründet.
- [ ] Andere Aggregate werden über ihre Identität referenziert.
- [ ] Domänenereignisse sind Tatsachen in der Vergangenheitsform.
- [ ] Integrationsverträge legen keine internen Modelle offen.
- [ ] Integrationsnachrichten können weder unbestätigten Zustand offenlegen noch nach dem Commit verloren gehen.
- [ ] Zustandsabhängige fachliche Autorisierung wird durch die Domäne geschützt.
- [ ] Tests decken gültiges und ungültiges Domänenverhalten ab.
- [ ] Nachrichtentests decken, soweit relevant, Rollback, Wiederholungen und doppelte Zustellung ab.
- [ ] Die architektonische Komplexität ist gerechtfertigt.

## Maßgebliche Regeln

- [DDD-CORE-001](../rules/00-core-principles.md)
- [DDD-UL-001](../rules/04-ubiquitous-language.md)
- [DDD-AGG-001](../rules/08-aggregates.md)
- [DDD-EVT-001](../rules/11-domain-events.md)
- [DDD-INF-001](../rules/13-infrastructure-layer.md)
- [DDD-TEST-001](../rules/15-testing.md)
