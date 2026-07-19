# Änderungsprotokoll

## Unveröffentlicht

- Transaktionssichere Veröffentlichungssemantik für Domänen- und Integrationsereignisse definiert.
- Zugriffskontrolle auf Anwendungsfälle von zustandsabhängiger fachlicher Autorisierung unterschieden.
- Die kontextfreie `Money`-Invariante durch ein `Price`-Beispiel im Vertriebskontext ersetzt.
- Reine Prüfaufgaben bleiben schreibgeschützt und verlangen dennoch Testempfehlungen.
- Normative Modalstärken ausdrücklich gemacht und automatisiert validiert.
- Stabile Referenz-IDs, offizielle Quellenlinks und automatisierte Richtlinienprüfungen ergänzt.
- Ein erzeugtes `d-check.mk` mit gepinnter, schreibgeschützter d-check-Prüfung für Markdown-Links, Anker, Regel-IDs, Codepfade, Spans und Host-Pfad-Offenlegung ergänzt.
- Projektdokumentation, normative Modalverben, Beispiele und Prüfmeldungen ins Deutsche übersetzt; stabile technische Schnittstellen unverändert gelassen.
- Projektlebenszyklus und DDD-Regellebenszyklus als unabhängige Zustandsmodelle dokumentiert und einen prüfbaren Regelstatus eingeführt.
- Den DDD-Regellebenszyklus als normative Regel `DDD-RLC-001` in das Regelwerk verschoben.
- Redundante Prompt-Kopien entfernt und die einzigartige Domänenanalyse-Struktur nach `checklists/domain-analysis.md` überführt.
- Die Dokumentklassen, ihre normative Priorität und ihre Referenzrichtung festgelegt, Hilfen und Beispiele mit maßgeblichen Regeln verknüpft und die Richtung als d-check-SDP-Matrix automatisiert geprüft.
- Den DDD-Regellebenszyklus direkt nach den Kernprinzipien eingeordnet und die übrigen Regeldateien ohne Änderung ihrer stabilen Regel-IDs neu nummeriert.
- Eine durchgängige B2B-Fallstudie zu Aggregatinvarianten, Bestellfreigabe, transaktionaler Outbox, Kontextübersetzung, Idempotenz und den erforderlichen Domänen- und Integrationstests ergänzt.
- Repository-spezifische Agentenanweisungen von der auslieferbaren Ziel-Repo-Vorlage getrennt und mit `DDD-READY-001` sowie einer Readiness-Prüfliste ein verbindliches Gate für fachliche Codeänderungen eingeführt.
- Die README auf Nutzen, unmittelbar mögliche Schritte, Motivation, Kerngedanke und Vertrauensmechanismen ausgerichtet und ihre Hauptstruktur im Richtlinienvertrag abgesichert.
- Die Regeltitel im Dokumentindex an die kanonischen Frontmatter-Titel angeglichen, die Titelkonsistenz im Validator automatisiert erzwungen und die Vertragsterminologie des Ziel-Repositorys vereinheitlicht (`Anwendungs-Handler`).
- Normative Regeln zu Aggregat-Transaktionsgrenze, optimistischer Nebenläufigkeit, Vertragsversionierung, Outbox-Veröffentlichung und Schichtreinheit geschärft sowie Subdomäne und Bounded Context abgegrenzt.
- Den Entscheidungsbaum um das einzelentitäre Aggregat, das Preis-Beispiel um eine Null-Prüfung und die Fallstudie um den geforderten Konfliktbefund ergänzt.
- Die SDP-Referenzrichtung um die bislang fehlenden Kanten (Projektsteuerung→Einstieg, nachgeordnete Klassen→Quellen) vervollständigt und den Validator gegen leere Regelabschnitte sowie dateiübergreifende Quellen-Fehlzuordnung abgesichert.
- Ein Eval-Gerüst für die Wirksamkeit des Regelwerks ergänzt: `evals/init-fixture.sh` setzt in einem angegebenen Zielverzeichnis ein Ziel-Repo auf und bündelt das Regelwerk unter `.ddd-harness/` (dokumentierter Mindestumfang, Hilfen optional über `--with-hilfen`), während eine schlanke Wurzel-`AGENTS.md` darauf verweist. Vier Akzeptanzszenarien (Falle, Readiness-Gating, gute Änderung, Über-Anwendung) über ein fiktives Lager-Projekt und ein Signal-Assert-Runner (`evals/grade.sh`) beschreiben die Prüfung. `evals/` ist über `scan.ignore` von der deterministischen Doku-Prüfung ausgenommen.
- Die Eval-Prompts dokumentiert und reproduzierbar gemacht: Wrapper- und Judge-Vorlagen unter `evals/prompts/` (mit/ohne Regelwerk sowie Judge-Rubrik) und `evals/run-scenario.sh`, das den Auftrag aus dem Szenario mit dem Wrapper zu einem fertigen Agenten-Prompt zusammensetzt.
- Eine ausführbare Verifikationsebene für code-erzeugende Eval-Szenarien ergänzt: ein per Digest gepinntes JDK-Image (`evals/Dockerfile`) kompiliert die vom Agenten implementierte Änderung im Ziel-Repo gegen versteckte Referenztests (`evals/verify/`) und liefert ein objektives PASS/FAIL. Die Eval-Ziele in ein eigenes `evals/Makefile` (`init`, `run`, `grade`, `image`, `verify`) getrennt; das Wurzel-`Makefile` bleibt auf die Regelwerk-Validierung beschränkt.
- Die Eval-Verifikation zu einer Triangulation kombiniert: jedes Szenario trägt eine objektive Referenzrubrik (`## Referenzlösung`), der Judge arbeitet als adversariales Panel mit maschinenlesbarem Verdikt, und `evals/consensus.sh` führt ausführbaren Test, Panel-Mehrheit und Signal-Assert zu einem Verdikt mit Konfidenz zusammen (Divergenz ⇒ menschliche Sichtung).
- Einen eigenständigen, ins Ziel-Repo lieferbaren Verifikations-Helfer ergänzt (`templates/ddd-verify/`): ein per Digest gepinntes JDK-Image prüft die Aggregatinvarianten eines Ziel-Repos gegen dessen **eigene** Tests unter `ddd-invariants/` (`make -C ddd-verify verify`), getrennt vom internen Eval-Harness. `init-fixture.sh --with-verify` legt Helfer und Beispieltest bei. `templates/` ist wie `evals/` aus der deterministischen Doku-Prüfung ausgenommen.
- Szenario 004 vom trivialen Notizfeld zu einem echten Über-Anwendungs-Test verschärft (Bestandshistorie, die zu Event Sourcing verleitet — an der Fallstudie geeicht, wo ein Ereignis berechtigt ist). Die Ablation bestätigt den Regelwerk-Effekt (002 und verschärftes 004 je mit Regelwerk 3/3, ohne 0/3, 3-Judge-Panel); Grader-Bereitschaftsextraktion (Wert in der Folgezeile) und die 004-Rubrik (`analysis-only` zulässig) dabei nachkalibriert.

## 0.1.0

- Ursprüngliche Repository-Struktur
- Zentrale DDD-Regeln
- Entscheidungshilfen
- Muster und Antimuster
- Prüflisten
- Wiederverwendbare Agentenprompts
- Quellen- und Attributionsdateien
