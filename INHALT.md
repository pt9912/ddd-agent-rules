# Dokumentindex

Dieser Index ist ein Navigationseinstieg. Die fachliche Autorität und die zulässige Abhängigkeitsrichtung der Ziele beschreibt die [Referenzrichtung der Dokumentation](docs/referenzrichtung.md).

## Einstieg und Projektsteuerung

- [Projektübersicht](README.md)
- [Agentenanweisungen für dieses Regel-Repository](AGENTS.md)
- [Agentenanweisungen für Ziel-Repositories](AGENTS.target.md)
- [Projektlebenszyklus](docs/projektlebenszyklus.md)
- [Referenzrichtung der Dokumentation](docs/referenzrichtung.md)

## Normative DDD-Regeln

- [DDD-CORE-001 – DDD gezielt anwenden](rules/00-core-principles.md)
- [DDD-RLC-001 – Den Lebenszyklus von DDD-Regeln ausdrücklich steuern](rules/01-rule-lifecycle.md)
- [DDD-READY-001 – Fachliche Änderungsbereitschaft vor der Umsetzung herstellen](rules/02-agent-readiness.md)
- [DDD-MOD-001 – Das Fachliche vor der Technik modellieren](rules/03-domain-modeling.md)
- [DDD-UL-001 – Eine Sprache je Bounded Context verwenden](rules/04-ubiquitous-language.md)
- [DDD-BC-001 – Bounded Contexts ausdrücklich abgrenzen](rules/05-bounded-contexts.md)
- [DDD-ENT-001 – Entitäten durch Identität und Verhalten modellieren](rules/06-entities.md)
- [DDD-VO-001 – Wertobjekte für beschreibende Domänenkonzepte verwenden](rules/07-value-objects.md)
- [DDD-AGG-001 – Invarianten innerhalb von Aggregatgrenzen schützen](rules/08-aggregates.md)
- [DDD-SVC-001 – Domänendienste nur für echte Domänenoperationen verwenden](rules/09-domain-services.md)
- [DDD-REP-001 – Repositories um Aggregatwurzeln entwerfen](rules/10-repositories.md)
- [DDD-EVT-001 – Fachlich bedeutsame Zustandsänderungen als Domänenereignisse modellieren](rules/11-domain-events.md)
- [DDD-APP-001 – Die Anwendungsschicht für Ablaufkoordination verwenden](rules/12-application-layer.md)
- [DDD-INF-001 – Infrastruktur von der Domäne abhängig machen](rules/13-infrastructure-layer.md)
- [DDD-INT-001 – Modelle an Kontextgrenzen ausdrücklich übersetzen](rules/14-context-integration.md)
- [DDD-TEST-001 – Fachliches Verhalten und Invarianten testen](rules/15-testing.md)
- [DDD-REF-001 – In kleinen fachlich sicheren Schritten refaktorieren](rules/16-refactoring.md)

## Entscheidungshilfen

- [Aggregat oder Entität?](decisions/aggregate-or-entity.md)
- [Bounded Context oder Modul?](decisions/bounded-context-or-module.md)
- [Domänenereignis oder Integrationsereignis?](decisions/domain-event-or-integration-event.md)
- [Domänendienst oder Anwendungsdienst?](decisions/domain-service-or-application-service.md)
- [Entität oder Wertobjekt?](decisions/entity-or-value-object.md)

## Muster

- [Aggregatwurzel](patterns/aggregate-root.md)
- [Anti-Corruption Layer](patterns/anti-corruption-layer.md)
- [Domänenereignis](patterns/domain-event.md)
- [Transaktionale Outbox](patterns/outbox.md)
- [Repository](patterns/repository.md)

## Antimuster

- [Anämisches Domänenmodell](anti-patterns/anemic-domain-model.md)
- [Generisches Repository](anti-patterns/generic-repository.md)
- [Gott-Aggregat](anti-patterns/god-aggregate.md)
- [Infrastrukturleck](anti-patterns/infrastructure-leakage.md)
- [Geteiltes Domänenmodell](anti-patterns/shared-domain-model.md)

## Prüflisten

- [DDD-Änderungsbereitschaft für Code-Agenten](checklists/agent-readiness.md)
- [Aggregate](checklists/aggregate-review.md)
- [Bounded Contexts](checklists/bounded-context-review.md)
- [DDD-Codeprüfung](checklists/code-review.md)
- [Domänenanalyse](checklists/domain-analysis.md)
- [Pull Requests](checklists/pull-request-review.md)

## Beispiele

- [Durchgängige Fallstudie: Eine B2B-Bestellung bestätigen](examples/realistic/bestellbestaetigung/README.md)
- [Gute Aggregatänderung](examples/good/aggregate.md)
- [Gutes kontextspezifisches Wertobjekt](examples/good/value-object.md)
- [Schlechte unmittelbare Änderung eines untergeordneten Objekts](examples/bad/direct-child-update.md)
- [Schlechte Infrastrukturabhängigkeit in der Domäne](examples/bad/infrastructure-in-domain.md)

## Quellen, Lizenz und Historie

- [Referenzkatalog](sources/references.md)
- [Quellenangaben](sources/attribution.md)
- [Lizenzhinweise](sources/licenses.md)
- [Inoffizielle deutsche Lizenzübersetzung](LICENSE.de.md)
- [Änderungsprotokoll](CHANGELOG.md)
