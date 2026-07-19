# Status / Handoff — Stand 2026-07-19

Working tree sauber, alle Änderungen auf `main`, `make test` grün (58 Dateien, 0
Befunde). 17 Commits diese Session (`e2c6940`..`d8437cc`).

## Kurzfassung dieser Session
1. Vollständiges inhaltliches Review des DDD-Regelwerks mit Fixes (Batches:
   Index-Titel, Regelschärfungen + Lücken, Entscheidungsbaum/Beispiele,
   SDP-Matrix/Validator).
2. Eine komplette **Wirksamkeits-Eval-Suite** unter `evals/` aufgebaut: Ablation
   mit/ohne Regelwerk, Triangulation aus Signal-Assert + ausführbarem Test +
   adversarialem Judge-Panel + Konsens.
3. Einen **lieferbaren Zielrepo-Verifikations-Helfer** (`templates/ddd-verify/`).
4. Drei Ablationsläufe gefahren → eine Regelwerk-Schwäche gefunden und behoben
   (EVT-001/CORE-001).

## Was existiert
### Regelwerk (validiert)
- `make test` (Wurzel): `validate.sh` + `policy-contract.sh` + `doc-check`
  (Docker, d-check v0.50.0 per Digest gepinnt). Grün.
- 17 Regeln `rules/00`–`16`; diese Session inhaltlich geschärft (s. CHANGELOG
  „Unveröffentlicht").

### Eval-Harness `evals/` (eigenes Makefile: `make -C evals <ziel>`)
- `init-fixture.sh` — Ziel-Repo aufsetzen; Regelwerk gebündelt unter
  `.ddd-harness/`; `--with-hilfen`, `--with-verify`.
- `run-scenario.sh` — Prompt aus Szenario-`## Aufgabe` + Wrapper (`prompts/`);
  `--ohne-regelwerk`.
- `grade.sh` — Signal-Assert gegen ` ```grading `-Block; Pass-Rate.
- `consensus.sh` — ausführbar + Judge-Panel + Signal → Verdikt + Konfidenz
  (Divergenz ⇒ PRÜFEN).
- `prompts/` — `runner-mit/ohne-regelwerk`, `judge` (panel-tauglich, `VERDIKT:`).
- `Dockerfile` + `docker-verify.sh` + `verify/003/` — ausführbare Verifikation
  (JDK-Image, versteckter Referenztest): `make -C evals image` /
  `verify DIR=.. SCENARIO=003`.
- Fixture: Bounded Context **Lager**, angereichert (`wareneingangVerbuchen` +
  Reservierungen mit `ReservierungId`).
- 4 Szenarien: 001 Falle, 002 Readiness-Gating, 003 gute Änderung (ausführbar),
  004 Über-Anwendung.

### Zielrepo-Helfer `templates/ddd-verify/`
- Portables, selbst-enthaltenes Docker-Template: ein echtes Zielrepo prüft seine
  EIGENEN Aggregatinvarianten (`ddd-invariants/`) reproduzierbar.

`evals/**` und `templates/**` sind aus d-check ausgenommen (`scan.ignore`).

## Ablationsbefunde (mit vs. ohne Regelwerk, 3-Judge-Panel + Konsens)
- **001** (Falle): beide Arme lösen die Falle; Regelwerk-Mehrwert = Regel-IDs +
  Readiness. [früher Lauf]
- **002** (Readiness-Gating): **3/3 vs 0/3** — starker Effekt; ohne Regelwerk wird
  die undokumentierte FIFO-Regel erfunden. Auf angereicherter Fixture bestätigt.
- **004** (Über-Anwendung, angereicherte Fixture): **2/3 vs 0/3**. Erkenntnis:
  Readiness-Gating dominiert; ein Regelwerk-Lauf (A-2) über-applizierte dennoch →
  EVT-001/CORE-001 geschärft.

## Regelwerk-Änderung aus dem Eval-Befund (der geschlossene Kreis)
`DDD-EVT-001`: „reine Nachvollziehbarkeit rechtfertigt kein Domänenereignis; ein
Ereignis braucht Konsument/Reaktion" (Entscheidungskriterium korrigiert + Verbot +
Prüfpunkt). `DDD-CORE-001`: Prüfpunkt ergänzt.

## Offene Punkte / morgen weiter (priorisiert)
1. **(optional) Bestätigungslauf 004** mit dem geschärften EVT-001 — rutscht
   A-2-artige Über-Anwendung jetzt seltener durch? (~9 Agenten)
2. **004 bleibt vom Readiness-Gating überlagert** — ein *rein* über-anwendungs-
   isolierender Test bräuchte eine voll-determinierte Aufgabe/Fixture ohne offene
   Fachfrage. Konzeptionell offen.
3. **001 und 003 nicht per Panel/Konsens ablatiert** (001 nur früh; 003 ist der
   ausführbare, mechanisch verifiziert). Bei Bedarf nachziehen.
4. **`decisions/domain-event-or-integration-event.md`** kurz gegen das geschärfte
   EVT-001 gegenlesen (grep zeigte keine „Nachvollziehbarkeit"-Rechtfertigung →
   vermutlich konsistent).
5. **Bewusst offen aus dem Ursprungs-Review** (unkritisch): LICENSE nicht in
   `INHALT.md` verlinkt; trivialer HTTPS-Check in `validate.sh`;
   `grade.sh`-Bereitschaftsheuristik bleibt grob (dokumentiert).
6. **Release:** CHANGELOG-Abschnitt „Unveröffentlicht" ist umfangreich — evtl. eine
   Version schneiden.

## Läufe-Artefakte (ephemer, im Scratchpad, NICHT committet)
Agenten-Antworten/Judge-Ausgaben liegen unter `…/scratchpad/abl` (002/004 dünn),
`…/scratchpad/abl2` (002/004 angereichert), `…/scratchpad/live` (001). Werden
aufgeräumt; die Befunde stehen in `evals/README.md` + `CHANGELOG.md`.

## Schnellreferenz
```sh
make test                                              # Regelwerk-Gates
make -C evals init DIR=/pfad/ziel                      # Ziel-Repo aufsetzen
make -C evals run SCENARIO=scenarios/00X-*.md DIR=/pfad/ziel OUT=/pfad/out/A.md [ARM=ohne]
make -C evals grade SCENARIO=scenarios/00X-*.md OUT="/pfad/out/A.md /pfad/out/B.md"
make -C evals image && make -C evals verify DIR=/pfad/ziel SCENARIO=003
./evals/consensus.sh --exec PASS --judge PASS --judge FAIL --signal PASS
```

Der vollständige Ablauf (Ziel-Repo, Prompts, Grading, Judge-Panel, Konsens) steht
in `evals/README.md`.
