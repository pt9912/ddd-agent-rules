# DDD-Agentenregeln

Ein strukturierter, deutschsprachiger Regelsatz für Code-Agenten, die Software mit Domain-Driven Design analysieren, erzeugen, prüfen oder refaktorieren.

## Was ist ddd-agent-rules?

`ddd-agent-rules` übersetzt DDD-Prinzipien in versionierte, verlinkte und automatisiert prüfbare Arbeitsanweisungen für Code-Agenten. Das Repository verbindet normative Regeln mit Entscheidungshilfen, Mustern, Antimustern, Prüflisten, Quellen und realistischen Beispielen.

Der [Dokumentindex](INHALT.md) erschließt den vollständigen Inhalt. Die wichtigsten Dokumentklassen sind:

- `rules/` — normative DDD-Regeln mit stabilen IDs, Priorität und Lebenszyklusstatus
- `decisions/` — Entscheidungshilfen für mehrdeutige Modellierungsfragen
- `patterns/` und `anti-patterns/` — empfohlene Lösungen und typische Fehlentwicklungen
- `checklists/` — ausführbare Prüflisten für Analyse, Readiness und Reviews
- `examples/` — kompakte Beispiele und eine durchgängige B2B-Fallstudie
- `sources/` — Referenzkatalog, Quellenangaben und Lizenzhinweise
- `docs/` — Projektlebenszyklus und Dokumentarchitektur

## Was kann ich heute tun?

### Den Regelsatz in einem Ziel-Repository einsetzen

1. Kopiere [AGENTS.target.md](AGENTS.target.md) als `AGENTS.md` in die Wurzel des Ziel-Repositorys. Das vorhandene [AGENTS.md](AGENTS.md) gilt ausschließlich für die Pflege dieses Regel-Repositorys.
2. Stelle mindestens `rules/` und `checklists/` dort unter denselben relativen Pfaden bereit.
3. Ergänze die Domänendokumentation, Tests und Build-Befehle des Ziel-Repositorys als fachliche Evidenz.
4. Lass den Code-Agenten vor einer nicht trivialen fachlichen Änderung die [Readiness-Prüfliste](checklists/agent-readiness.md) anwenden.
5. Übernimm `decisions/`, `patterns/`, `anti-patterns/` und `examples/`, wenn der Agent auch auf die ergänzenden Hilfen zugreifen soll.

Der Agent lädt die fundamentalen Regeln immer und ergänzt nur die Regeln, die zur Aufgabe passen. Befunde nennen stabile Regel-IDs, zum Beispiel:

```text
Verstoß: DDD-AGG-001
Die Entität Bestellposition wird außerhalb der Aggregatwurzel Bestellung verändert.
```

### Das Repository erkunden

- Beginne beim [Dokumentindex](INHALT.md).
- Nutze die [Domänenanalyse-Prüfliste](checklists/domain-analysis.md) für eine erste fachliche Erkundung.
- Lies die [Fallstudie zur Bestellbestätigung](examples/realistic/bestellbestaetigung/README.md), um das Zusammenspiel von Aggregat, Freigabe, Outbox, Kontextübersetzung und Tests zu sehen.

### Den Regelsatz lokal prüfen

Führe `make test` aus. Docker ist erforderlich, weil d-check reproduzierbar in einem Container ausgeführt wird.

## Warum ddd-agent-rules?

Code-Agenten können vorhandenen Code schnell verändern, verfügen aber nicht automatisch über das fehlende Fachwissen. Ohne ausdrückliche Leitplanken besteht die Gefahr, dass sie:

- Datenbankbeziehungen mit Aggregatgrenzen verwechseln,
- etablierte Domänensprache durch generische Begriffe ersetzen,
- Invarianten in Handler oder Infrastruktur verschieben,
- interne Modelle über Kontextgrenzen hinweg teilen,
- Integrationsereignisse vor dem Commit veröffentlichen oder
- DDD-Muster ohne nachgewiesenen fachlichen Nutzen einführen.

Der Regelsatz macht die dafür notwendigen Entscheidungen sichtbar und prüfbar. Er hilft, fachliches Verhalten zu bewahren, Kontextgrenzen zu respektieren und architektonische Änderungen in fachlichen Begriffen zu erklären. DDD wird dabei nicht mit Microservices, CQRS oder Event Sourcing gleichgesetzt.

## Kerngedanke

Ein Code-Agent darf DDD nicht aus Frameworks, Tabellen oder üblichen Mustern ableiten. Er braucht ein begrenztes Modell, etablierte Sprache, bekannte Invarianten, ein klares Änderungsziel und ausführbare Verifikation.

```text
Änderungsauftrag + fachliche Evidenz
                 │
                 ▼
      ready | conditional | analysis-only
                 │
                 ▼
Bounded Context + Modell + Invarianten
                 │
                 ▼
       Änderung + passende Tests
```

Die normative [Readiness-Regel](rules/02-agent-readiness.md) verhindert, dass fehlende Fachregeln erfunden werden. Bei wesentlichen offenen Fragen bleibt die Arbeit auf Analyse und Klärung begrenzt.

Normative Regeln verwenden die Schlüsselwörter `MUSS`, `DARF NICHT`, `SOLLTE`, `SOLLTE NICHT` und `KANN`. Ihre Priorität ist `mandatory`, `recommended` oder `contextual`. Ihr Status ist unabhängig vom Zustand des Projekts:

- Der [Projektlebenszyklus](docs/projektlebenszyklus.md) steuert Entwicklung, Validierung, Veröffentlichung, Wartung und Archivierung des Repositorys.
- Der [DDD-Regellebenszyklus](rules/01-rule-lifecycle.md) steuert die fachliche Gültigkeit jeder einzelnen Regel.

Auch die Dokumentabhängigkeiten sind gerichtet: Beispiele verweisen auf Hilfen und Regeln, Hilfen auf Regeln und Regeln auf Quellen. Die [Referenzrichtung](docs/referenzrichtung.md) verhindert, dass normative Regeln von nachgeordneten Erläuterungen abhängig werden.

## Was macht es vertrauenswürdig?

### Explizite und nachvollziehbare Regeln

- Jede normative Regel besitzt eindeutige Metadaten, eine stabile ID, Priorität und Status.
- Verpflichtungen, Verbote, Entscheidungskriterien und Prüfhinweise sind getrennt sichtbar.
- Regeln verweisen über stabile Quellen-IDs auf den [Referenzkatalog](sources/references.md).
- Entscheidungen zu Readiness, Regelstatus und Dokumentrichtung sind als überprüfbare Invarianten dokumentiert.

### Automatisierte Freigabegates

`make test` verbindet drei unabhängige Prüfungen:

- `./scripts/validate.sh` prüft Regelmetadaten, Lebenszyklusstatus, eindeutige IDs, Modalität und Quellen-IDs.
- `./tests/policy-contract.sh` schützt kritische fachliche und Governance-Entscheidungen vor unbeabsichtigtem Drift.
- Das aus `d-check.mk` bereitgestellte Ziel `doc-check` prüft Markdown-Links und -Anker, Regelverweise, SDP-Referenzrichtung, Codepfade, Code-Spans und offengelegte Host-Pfade.

d-check v0.50.0 wird über einen geprüften Image-Digest gepinnt und ohne Netzwerk mit schreibgeschütztem Repository-Mount ausgeführt. Externe HTTP-Links werden nur über das bewusste Netzwerkziel `make d-check-external` geprüft. Weitere Betriebsdetails beschreibt die [d-check-Betriebsreferenz](https://github.com/pt9912/d-check/blob/main/docs/user/operations.md).

### Transparente Grenzen

- Beispiele ersetzen keine Fachentscheidung; die Fallstudie benennt ihre Annahmen und Auslassungen.
- Die Projektdokumentation und Prüfmeldungen sind deutsch, stabile technische Schnittstellen bleiben unverändert.
- Der maßgebliche Lizenztext steht in `LICENSE`; eine unverbindliche deutsche Übersetzung bietet [LICENSE.de.md](LICENSE.de.md). Weitere Hinweise enthält der [Lizenzkatalog](sources/licenses.md).
