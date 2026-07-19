# Referenzrichtung der Dokumentation

## Zweck

Dieses Dokument definiert, welche Dokumentklassen voneinander abhängen dürfen. Die Richtung folgt dem Stable-Dependencies-Prinzip (SDP): Ein weniger maßgebliches Dokument darf auf ein maßgeblicheres Dokument verweisen; die maßgebliche Vorgabe darf nicht von ihrer Erläuterung oder einem Beispiel abhängen.

Ein technisch gültiger Link ist damit noch kein fachlich zulässiger Link. `d-check` prüft beides: Existenz und Anker über `links` und `anchors`, die zulässige Abhängigkeitsrichtung über `matrix`.

## Dokumentklassen und Priorität

| Priorität | Klasse | Pfade | Rolle |
| --- | --- | --- | --- |
| Navigation | Einstieg | `README.md`, `AGENTS.md`, `AGENTS.target.md`, `INHALT.md` | Führt gezielt in alle relevanten Teile des Repositorys oder dient als auslieferbarer Ziel-Repo-Einstieg. |
| Eigenständig | Projektsteuerung | `docs/*.md` | Regelt Projektabläufe und Dokumentarchitektur, nicht die fachliche Gültigkeit von DDD-Regeln. |
| 1 | Regeln | `rules/*.md` | Normative, versionierte DDD-Vorgaben. |
| 2 | Hilfen | `decisions/*.md`, `patterns/*.md`, `checklists/*.md` | Erklären und operationalisieren Regeln. |
| 3 | Beispiele | `anti-patterns/*.md`, `examples/**/*.md` | Veranschaulichen erlaubtes oder problematisches Verhalten. |
| Evidenz | Quellen | `sources/*.md` | Belegen Regeln, geben aber keine projektinternen Vorgaben vor. |
| Historisch | Historie | `CHANGELOG.md`, `LICENSE.de.md` | Dokumentiert Änderungen oder eine nicht normative Übersetzung. |

Die Zahlen bezeichnen die normative Priorität. Navigation, Projektsteuerung, Evidenz und Historie liegen auf eigenen Achsen und werden nicht künstlich in diese Rangfolge eingeordnet.

## Zulässige Richtung

Die normative Referenzkette lautet:

```text
Beispiele → Hilfen → Regeln → Quellen
     └────────────────→ Regeln
```

- Hilfen DÜRFEN Regeln referenzieren, Regeln DÜRFEN NICHT von Hilfen abhängen.
- Beispiele DÜRFEN Hilfen und Regeln referenzieren, beide DÜRFEN NICHT von Beispielen abhängen.
- Regeln DÜRFEN Quellen referenzieren, Quellen DÜRFEN NICHT von Regeln oder nachgeordneten Dokumenten abhängen.
- Einstiegspunkte DÜRFEN zu allen Klassen navigieren. Andere Klassen DÜRFEN NICHT von Einstiegspunkten abhängen.
- Projektsteuerung und Regeln DÜRFEN einander referenzieren, wenn ein Projektprozess und eine normative Regel ausdrücklich getrennte Zustandsmodelle koordinieren. Das gilt insbesondere für Projekt- und DDD-Regellebenszyklus.
- Historische Abschnitte `Historie` und `Geschichte` werden von der Richtungsprüfung ausgenommen.

## Zielstatus von Regelverweisen

Anwendbare Erläuterungen und Beispiele DÜRFEN NICHT auf Regeln mit `draft`, `deprecated`, `superseded` oder `retired` als gültige Vorgabe verweisen. Solche historischen Bezüge gehören in einen ausgenommenen historischen Abschnitt oder müssen auf die aktive Nachfolgeregel umgeleitet werden. Der Status selbst wird durch den [DDD-Regellebenszyklus](../rules/01-rule-lifecycle.md) bestimmt.

## Redaktionsregeln

- Neue Hilfen und Beispiele MÜSSEN unter `Maßgebliche Regeln` mindestens ihre normative Grundlage verlinken.
- Ein Link SOLLTE auf die unmittelbar maßgebliche Regel führen, nicht nur auf einen Einstiegspunkt oder ein thematisch ähnliches Beispiel.
- Doppelte Erläuterungslinks sind nur sinnvoll, wenn jede Zielregel eine eigene Aussage des Dokuments trägt.
- Externe Quellen werden zentral im Referenzkatalog geführt und von Regeln über stabile Quellen-IDs verlinkt.
- Eine neue Dokumentklasse oder Ausnahme MUSS in `.d-check.yml` und in diesem Dokument gemeinsam ergänzt werden.

## Prüfung

`make doc-check` prüft den Dokumentgraphen einschließlich der SDP-Matrix. `make test` führt diese Prüfung zusammen mit den inhaltlichen Regel- und Richtlinienprüfungen als Freigabegate aus.
