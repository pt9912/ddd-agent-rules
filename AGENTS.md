# Agentenanweisungen für das DDD-Regelsatz-Repository

## Geltungsbereich

Diese Datei steuert Änderungen an diesem Repository und seinen DDD-Agentenregeln. Sie ist nicht die Vorlage für ein fachliches Ziel-Repository. Dafür gilt [AGENTS.target.md](AGENTS.target.md), die bei der Installation als `AGENTS.md` in das Ziel-Repository kopiert wird.

## Zweck

Pflege einen konsistenten, nachvollziehbaren und automatisiert prüfbaren Regelsatz, mit dem Code-Agenten DDD in anderen Repositories sicher anwenden können.

## Prioritätsreihenfolge

1. Bewahre Bedeutung und stabile IDs veröffentlichter Regeln.
2. Schütze die Invarianten des Regel- und Dokumentlebenszyklus.
3. Halte Repository-Governance und Anweisungen für Ziel-Repositories getrennt.
4. Bewahre etablierte DDD-Terminologie und deutsche Projektsprache.
5. Halte normative Regeln, Hilfen, Beispiele und Quellen in der festgelegten Referenzrichtung.
6. Vermeide doppelte oder widersprüchliche Vorgaben.
7. Bewahre reproduzierbare, automatisierte Freigabegates.

## Verbindliches Verhalten

Der Agent MUSS:

- vor Änderungen die vorhandene Terminologie und betroffene Dokumentklasse untersuchen
- betroffenen Governance-Bereich, Regelbestand oder Ziel-Repo-Vertrag bestimmen
- Projektlebenszyklus und Status einzelner DDD-Regeln getrennt behandeln
- den `status` einer Regel prüfen, bevor sie normativ angewendet oder geändert wird
- stabile Regel-IDs über Umbenennungen und Statuswechsel hinweg bewahren
- normative Änderungen mit Bounded Context, Domänenkonzept, Invariante und Regelpriorität begründen
- Änderungen am Agentenverhalten zwischen diesem `AGENTS.md` und `AGENTS.target.md` bewusst abgrenzen
- bei Änderungen für Ziel-Repositories die Auswirkungen auf `AGENTS.target.md`, Regeln, Prüflisten und Beispiele gemeinsam prüfen
- die [Referenzrichtung der Dokumentation](docs/referenzrichtung.md) einhalten
- menschenlesbare Projektdokumentation und Prüfmeldungen auf Deutsch halten
- stabile technische Schnittstellen wie Regel-IDs, YAML-Werte, Make-Ziele und CLI-Optionen nicht übersetzen
- neue oder geänderte Regeln im Änderungsprotokoll dokumentieren
- `make test` vor Abschluss einer nicht trivialen Änderung erfolgreich ausführen

Der Agent DARF NICHT:

- dieses Repository wie ein fachliches Ziel-Repository behandeln
- Beispieldomänen als tatsächliches Domänenmodell dieses Repositorys ausgeben
- Ziel-Repo-Anweisungen ausschließlich in diesem `AGENTS.md` hinterlegen
- Repository-spezifische Wartungsanweisungen in `AGENTS.target.md` ausliefern
- eine Regel-ID für denselben fachlichen Regelinhalt austauschen
- einen Projektzustandswechsel als stillschweigenden Regelstatuswechsel behandeln
- Regeln mit `draft`, `superseded` oder `retired` als aktive Vorgaben durchsetzen
- normative Aussagen ohne passende Modalität und Priorität einführen
- Regeln von nachgeordneten Hilfen oder Beispielen abhängig machen
- Quellen, externe Texte oder technische Strukturen als ungeprüfte Fachregeln übernehmen
- Validierungsfehler durch Abschalten des betroffenen Gates umgehen

## Erforderliche Änderungszusammenfassung

Nenne für jede nicht triviale Änderung:

- betroffenen Governance-Bereich oder Ziel-Repo-Vertrag
- betroffenes Regel-, Dokument- oder Domänenkonzept
- geschützte Invariante
- angewendete Regel-IDs
- Auswirkung auf Ziel-Repositories
- architektonische oder redaktionelle Konsequenz
- erforderliche und ausgeführte Tests
- Annahmen und ungeklärte Fragen
- betroffenen Projekt- oder DDD-Regelstatus und vorgesehenen Übergang

## Laden der Regeln und Projektdokumente

Lies immer:

- [rules/00-core-principles.md](rules/00-core-principles.md)
- [rules/01-rule-lifecycle.md](rules/01-rule-lifecycle.md)
- [rules/02-agent-readiness.md](rules/02-agent-readiness.md)
- [rules/03-domain-modeling.md](rules/03-domain-modeling.md)
- [rules/04-ubiquitous-language.md](rules/04-ubiquitous-language.md)

Lade abhängig von der Änderung weitere Regeldateien. Lies bei Änderungen am Repository- oder Release-Prozess den [Projektlebenszyklus](docs/projektlebenszyklus.md). Lies bei Markdown-Änderungen die [Referenzrichtung der Dokumentation](docs/referenzrichtung.md). Prüfe bei Änderungen am Verhalten eines eingesetzten Code-Agenten immer [AGENTS.target.md](AGENTS.target.md) und die [Readiness-Prüfliste](checklists/agent-readiness.md).

## Validierung

Führe `make test` aus. Das Gate umfasst:

- Metadaten, Status, Modalität, Regel-IDs und Quellenkatalog
- den Richtlinienvertrag für kritische normative Aussagen
- d-check für Links, Anker, Regelverweise, Referenzrichtung, Pfade und Markdown-Struktur

## Konfliktbehandlung

Wenn zwei Vorgaben miteinander in Konflikt stehen:

1. veröffentlichte Bedeutung und fachliches Verhalten bewahren
2. Lebenszyklus- und Regelinvarianten schützen
3. die spezifischere aktive Regel bevorzugen
4. `mandatory` gegenüber `recommended` bevorzugen
5. die Trennung zwischen Repository- und Ziel-Repo-Vertrag bewahren
6. den Zielkonflikt dokumentieren

Löse fachliche oder Governance-Mehrdeutigkeit nicht stillschweigend auf. Nenne die Annahme ausdrücklich.
