# Prüfliste für die DDD-Änderungsbereitschaft

Diese Prüfliste entscheidet, ob ein Code-Agent eine fachliche Änderung umsetzen kann oder zunächst analysieren und offene Fragen klären muss.

## Änderungsauftrag

- [ ] Ziel und gewünschtes Ergebnis der Änderung sind beschrieben.
- [ ] Zu bewahrendes öffentliches und fachliches Verhalten ist benannt.
- [ ] Ausdrücklich erlaubte Verhaltensänderungen sind abgegrenzt.
- [ ] Betroffene Benutzer, Prozesse oder externen Verträge sind bekannt.

## Fachliche Evidenz

- [ ] Vorhandene Domänendokumentation und Architekturentscheidungen wurden geprüft.
- [ ] Bestehende Tests und beobachtbares Codeverhalten wurden geprüft.
- [ ] Technische Strukturen werden nur als Indizien, nicht als Fachmodell behandelt.
- [ ] Widersprüche zwischen Auftrag, Dokumentation, Tests und Code sind benannt.
- [ ] Für wesentliche Widersprüche liegt eine Klärung oder ausdrückliche Entscheidung vor.

## Modellkontext

- [ ] Der betroffene Bounded Context ist bestimmt.
- [ ] Maßgebliche Domänenbegriffe und ihre Bedeutung sind bestimmt.
- [ ] Betroffenes Aggregat oder Domänenkonzept ist bestimmt.
- [ ] Relevante Invarianten und Zustandsübergänge sind beschrieben.
- [ ] Eigentümerschaft und Übersetzung an berührten Kontextgrenzen sind bekannt.

## Verifikation

- [ ] Build-, Test- und Validierungsbefehle sind auffindbar und ausführbar.
- [ ] Bestehende Tests schützen das zu bewahrende Verhalten oder fehlende Tests sind benannt.
- [ ] Für veränderte Invarianten sind Domänentests vorgesehen.
- [ ] Für Persistenz-, Transaktions- oder Kontextgrenzen sind Integrationstests vorgesehen.
- [ ] Nicht ausführbare Prüfungen und ihre Folgen sind ausdrücklich dokumentiert.

## Bereitschaftsentscheidung

- [ ] `ready`: Fachlicher Umfang und Verifikation sind ausreichend bestimmt.
- [ ] `conditional`: Begrenzte Annahmen sind ausdrücklich und verändern keine wesentliche Grenze oder Invariante.
- [ ] `analysis-only`: Eine offene Frage kann Modellgrenze, Invariante oder Verhalten wesentlich verändern.
- [ ] Annahmen und ungeklärte Domänenfragen stehen in der Änderungszusammenfassung.

Genau eine Bereitschaftsstufe wird als Ergebnis gewählt. Bei `analysis-only` darf der Agent Optionen untersuchen und erklären, aber keine fachliche Umsetzung als endgültig oder sicher darstellen.

## Maßgebliche Regeln

- [DDD-CORE-001](../rules/00-core-principles.md)
- [DDD-READY-001](../rules/02-agent-readiness.md)
- [DDD-MOD-001](../rules/03-domain-modeling.md)
- [DDD-UL-001](../rules/04-ubiquitous-language.md)
- [DDD-BC-001](../rules/05-bounded-contexts.md)
- [DDD-TEST-001](../rules/15-testing.md)
