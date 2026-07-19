# DDD-Agentenregeln

Ein strukturierter Regelsatz für Code-Agenten, die Software mit Domain-Driven Design analysieren, erzeugen, prüfen und refaktorieren.

Der [Dokumentindex](INHALT.md) bietet einen vollständigen thematischen Einstieg in Regeln, Hilfen, Beispiele und Projektunterlagen.

## Ziele

- Fachliches Verhalten bei automatisierten Codeänderungen bewahren.
- Domänengrenzen ausdrücklich machen.
- Aggregatinvarianten schützen.
- Das Eindringen von Infrastrukturbelangen in das Domänenmodell verhindern.
- Nachvollziehbare und erklärbare Agentenentscheidungen erzeugen.
- Verbindliche Regeln von kontextabhängigen Hinweisen unterscheiden.

## Repository-Struktur

- [AGENTS.md](AGENTS.md) — Arbeitsanweisungen für die Pflege dieses Regel-Repositorys
- [AGENTS.target.md](AGENTS.target.md) — als `AGENTS.md` auszuliefernde Vorlage für Ziel-Repositories
- `rules/` — normative DDD-Regeln
- `decisions/` — Entscheidungshilfen für mehrdeutige Modellierungsfragen
- `patterns/` — empfohlene Implementierungsmuster
- `anti-patterns/` — häufige Entwurfsfehler und Erkennungskriterien
- `checklists/` — ausführbare Prüflisten
- `examples/` — kompakte gute und schlechte Beispiele
- `sources/` — Referenzen, Quellenangaben und Lizenzhinweise
- `docs/` — Projektlebenszyklus und ergänzende Prozessdokumentation

## Lebenszyklen

Der [Projektlebenszyklus](docs/projektlebenszyklus.md) steuert Entwicklung, Validierung, Veröffentlichung, Wartung und Archivierung des Repositorys. Die normative Regel [DDD-Regellebenszyklus](rules/01-rule-lifecycle.md) steuert dagegen die fachliche Gültigkeit jeder einzelnen Regel. Beide Zustandsmodelle sind unabhängig; ein Übergang muss jeweils ausdrücklich dokumentiert werden.

## Dokumentverweise

Die [Referenzrichtung der Dokumentation](docs/referenzrichtung.md) ordnet Einstiegspunkte, Projektsteuerung, normative Regeln, Hilfen, Beispiele, Quellen und Historie. Entscheidungshilfen und Beispiele verweisen auf ihre maßgeblichen Regeln; Regeln verweisen nur auf stabilere Grundlagen wie den Quellenkatalog oder ausdrücklich getrennte Projektprozesse. `d-check` erzwingt diese Richtung als SDP-Matrix.

## Verwendung

Für Arbeiten an diesem Repository gilt [AGENTS.md](AGENTS.md). Um den Regelsatz in einem Ziel-Repository einzusetzen, kopiere [AGENTS.target.md](AGENTS.target.md) dort als `AGENTS.md` in die Wurzel und stelle mindestens `rules/` und `checklists/` unter denselben relativen Pfaden bereit.

Der Agent lädt die fundamentalen Regeln einschließlich des Readiness-Gates immer und nur die zusätzlichen Regeldateien, die für die aktuelle Aufgabe relevant sind. Befunde sollten Regel-IDs nennen, zum Beispiel:

```text
Verstoß: DDD-AGG-001
Die Entität Bestellposition wird außerhalb der Aggregatwurzel Bestellung verändert.
```

## Normative Schlüsselwörter

Die Wörter `MUSS`, `DARF NICHT`, `SOLLTE`, `SOLLTE NICHT` und `KANN` werden als normative Anforderungen verwendet.

- `MUSS`: verbindlich
- `DARF NICHT`: verboten
- `SOLLTE`: empfohlener Standard
- `SOLLTE NICHT`: nicht empfohlener Standard
- `KANN`: optional oder kontextabhängig

Jeder normative Listenpunkt in `rules/` beginnt mit einem dieser Schlüsselwörter. Verbindliche Regeln verwenden `MUSS` und `DARF NICHT`, empfohlene Regeln verwenden `SOLLTE` und `SOLLTE NICHT`. Abschnittsüberschriften sind beschreibend und überschreiben nicht das Schlüsselwort eines einzelnen Listenpunkts.

## Regelprioritäten

- `mandatory` — eine Abweichung erfordert eine ausdrückliche Begründung
- `recommended` — bevorzugter Standard mit dokumentierten Ausnahmen
- `contextual` — abhängig von Domäne, Größenordnung und Architektur

## Lizenz

Der offizielle und rechtlich maßgebliche englische Lizenztext steht in `LICENSE`. Eine unverbindliche deutsche Übersetzung steht in [LICENSE.de.md](LICENSE.de.md). Weitere Hinweise enthält `sources/licenses.md`.

## Sprachkonvention

Die Projektdokumentation und die menschenlesbaren Prüfmeldungen sind auf Deutsch. Stabile technische Schnittstellen bleiben unverändert, darunter Dateipfade, Regel-IDs, YAML-Schlüssel und -Werte, Make-Ziele und CLI-Optionen. Offizielle Werktitel werden für eindeutige Quellenangaben in ihrer Originalsprache wiedergegeben.

## Validierung

Führe `make test` aus, um alle Repository-Prüfungen zu starten:

- `./scripts/validate.sh` prüft Regelmetadaten, Lebenszyklusstatus, eindeutige Regel-IDs, konsistente Modalität sowie die Übereinstimmung von Quellen-IDs und Katalog.
- `./tests/policy-contract.sh` schützt die Entscheidungen zu Ereigniszustellung, Autorisierung, Prüfumfang, Wertobjekten und getrennten Lebenszyklen.
- Das vom erzeugten `d-check.mk` bereitgestellte Ziel `doc-check` prüft Markdown-Links und -Anker, verlinkte DDD-Regel-IDs, die zulässige Referenzrichtung, Codepfade, Code-Spans und die Offenlegung von Host-Pfaden in einem schreibgeschützten Container ohne Netzwerk.

Die Include-Datei `d-check.mk` wird von d-check v0.50.0 mit `--print-mk` erzeugt. Das Projekt-`Makefile` liefert nur den geprüften Image-Digest und bindet `doc-check` in `make test` ein. `make doc-help` listet die erzeugten Ziele auf. Für `make test` ist Docker erforderlich. `make d-check-external` prüft externe HTTP-Links separat; dieses Ziel erlaubt bewusst Netzwerkzugriff und gehört nicht zur deterministischen Standardtestsuite. Siehe die [d-check-Betriebsreferenz](https://github.com/pt9912/d-check/blob/main/docs/user/operations.md).
