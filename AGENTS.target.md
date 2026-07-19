# DDD-Agentenanweisungen für Ziel-Repositories

## Verwendung

Diese Datei ist die Vorlage für ein Ziel-Repository, in dem der DDD-Regelsatz eingesetzt wird. Kopiere sie dort als `AGENTS.md` in die Repository-Wurzel und stelle die referenzierten Verzeichnisse `rules/` und `checklists/` unter denselben relativen Pfaden bereit.

Sie steuert nicht die Pflege des Regelsatz-Repositorys selbst; dafür gilt dessen eigenes `AGENTS.md`.

## Zweck

Wende die Prinzipien des Domain-Driven Design beim Analysieren, Erzeugen, Prüfen oder Refaktorieren von Code an.

## Prioritätsreihenfolge

1. Bewahre bestehendes fachliches Verhalten.
2. Schütze ausdrückliche fachliche Invarianten.
3. Respektiere die Grenzen von Bounded Contexts.
4. Bewahre die etablierte Domänensprache.
5. Bevorzuge ausdrückliche Domänenkonzepte gegenüber generischen Abstraktionen.
6. Halte Infrastrukturbelange aus dem Domänenmodell heraus.
7. Vermeide architektonische Komplexität ohne nachgewiesenen fachlichen Nutzen.

## DDD-Änderungsbereitschaft

Vor einer nicht trivialen fachlichen Änderung MUSS der Agent die [Prüfliste für die DDD-Änderungsbereitschaft](checklists/agent-readiness.md) anwenden und das Ergebnis als `ready`, `conditional` oder `analysis-only` bestimmen.

Der Agent MUSS zuerst vorhandene Fachbegriffe, Dokumentation, Tests und Code untersuchen. Fehlt eine Information, die Bounded Context, Aggregatgrenze, Invariante oder öffentliches Verhalten wesentlich verändern kann, MUSS er die Arbeit auf Analyse und Klärung begrenzen. Er DARF NICHT die fehlende Fachregel aus Datenbankschema, Frameworkstruktur oder einem üblichen DDD-Muster erfinden.

## Verbindliches Verhalten

Der Agent MUSS:

- die vorhandene Domänenterminologie prüfen, bevor neue Namen eingeführt werden
- den betroffenen Bounded Context bestimmen
- das betroffene Aggregat oder Domänenkonzept und seine Invarianten bestimmen
- öffentliches Verhalten bewahren, sofern die Aufgabe es nicht ausdrücklich ändert
- Aggregatänderungen über die Aggregatwurzel leiten
- Domänenlogik aus Controllern, Transport-Handlern und Persistenzadaptern heraushalten
- Domänenereignisse von Integrationsereignissen unterscheiden
- Integrationsereignisse erst nach dem Commit der auslösenden Transaktion veröffentlichen
- technische Zugriffskontrolle von zustandsabhängiger fachlicher Autorisierung unterscheiden
- Architekturänderungen in fachlichen Begriffen erklären
- bei Implementierung und Refaktorierung Tests für betroffene Invarianten ergänzen oder aktualisieren
- bei reinen Prüfaufgaben fehlende und erforderliche Tests melden, ohne Dateien zu verändern
- Annahmen, Evidenzkonflikte und ungeklärte Domänenfragen ausdrücklich nennen
- den `status` einer Regel prüfen, bevor sie normativ angewendet wird

Der Agent DARF NICHT:

- Microservices allein deshalb einführen, weil DDD verwendet wird
- Aggregatgrenzen allein aus Datenbankbeziehungen ableiten
- standardmäßig generische Repositories erstellen
- Aggregatwurzeln bei Zustandsänderungen umgehen
- veränderliche Interna eines Aggregats offenlegen
- standardmäßig ein gemeinsames Domänenmodell über mehrere Bounded Contexts teilen
- fachliche Regeln in Infrastrukturcode verschieben
- etablierte Domänenbegriffe ohne Beleg umbenennen
- zustandsabhängige fachliche Autorisierung ausschließlich in einem Application Handler belassen
- Integrationsnachrichten für noch nicht bestätigte Zustandsänderungen veröffentlichen
- Regeln mit `draft`, `superseded` oder `retired` als aktive Vorgaben durchsetzen
- eine `analysis-only`-Aufgabe als sichere fachliche Implementierung abschließen

## Erforderliche Änderungszusammenfassung

Nenne für jeden nicht trivialen Vorschlag:

- Bereitschaftsstufe und maßgebliche Evidenz
- betroffenen Bounded Context
- betroffenes Aggregat oder Domänenkonzept
- relevante Invariante
- angewendete Regel-IDs
- architektonische Konsequenz
- erforderliche und ausgeführte Tests
- Annahmen, Evidenzkonflikte und ungeklärte Domänenfragen
- betroffenen DDD-Regelstatus und vorgesehenen Übergang, falls Regeln selbst geändert werden

## Laden der Regeln

Lies immer:

- [rules/00-core-principles.md](rules/00-core-principles.md)
- [rules/01-rule-lifecycle.md](rules/01-rule-lifecycle.md)
- [rules/02-agent-readiness.md](rules/02-agent-readiness.md)
- [rules/03-domain-modeling.md](rules/03-domain-modeling.md)
- [rules/04-ubiquitous-language.md](rules/04-ubiquitous-language.md)

Lade abhängig von der Aufgabe weitere Regeldateien.

## Konfliktbehandlung

Wenn zwei Regeln oder fachliche Belege miteinander in Konflikt stehen:

1. fachliches Verhalten bewahren
2. Invarianten schützen
3. die spezifischere bestätigte Fachentscheidung bevorzugen
4. die spezifischere aktive Regel bevorzugen
5. `mandatory` gegenüber `recommended` bevorzugen
6. den Ziel- oder Evidenzkonflikt dokumentieren

Löse fachliche Mehrdeutigkeit nicht stillschweigend auf. Nenne die Annahme ausdrücklich und bleibe bei wesentlicher Auswirkung in `analysis-only`.
