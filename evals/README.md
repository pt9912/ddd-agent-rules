# Wirksamkeits-Evaluierung des Regelwerks

Die deterministischen Gates (`make test`: `validate.sh`, `policy-contract.sh`,
`doc-check`) prüfen die **innere Konsistenz** des Regelwerks. Sie sagen nichts
darüber, ob das Regelwerk das **Verhalten eines Code-Agenten** tatsächlich
korrekt lenkt.

Diese Ebene testet die Wirksamkeit: Ein Code-Agent wird mit dem Regelwerk gegen
ein **fiktives Ziel-Repo** gestellt und sein Verhalten gegen Akzeptanzkriterien
geprüft.

## Bestandteile

- `fixture/` — das fiktive Projekt (Bounded Context **Lager**): Domänendoku,
  Seed-Code, Build-Befehle. Enthält **nicht** das Regelwerk selbst.
- `scenarios/` — Akzeptanzszenarien (Aufgabe + maschinenlesbare Kriterien im
  ```grading-Block). Diese werden dem Agenten **nicht** ins Ziel-Repo gelegt;
  sie sind der Prüfmaßstab.
- `grade.sh` — Signal-Assert-Runner: bewertet Agenten-Antworten gegen den
  ```grading-Block eines Szenarios und meldet die Pass-Rate.
- `prompts/` — die Wrapper-Prompts, mit denen die Agenten aufgerufen werden:
  `runner-mit-regelwerk.md`, `runner-ohne-regelwerk.md` (Ablationsarm) und
  `judge.md` (LLM-Judge-Rubrik). So ist ein Lauf reproduzierbar: der **Auftrag**
  kommt aus dem Szenario, der **Wrapper** aus `prompts/`. Platzhalter:
  `{{repo}}`, `{{aufgabe}}`, `{{ausgabe}}` (Runner) bzw. `{{szenario}}`,
  `{{antworten}}` (Judge).
- `run-scenario.sh` — setzt aus einer Wrapper-Vorlage, dem `## Aufgabe`-Block
  eines Szenarios und den Zielpfaden den fertigen Agenten-Prompt zusammen
  (Ausgabe auf stdout).
- `Dockerfile` + `docker-verify.sh` + `verify/` — die **ausführbare Verifikation**
  (Ebene 1) für code-erzeugende Szenarien: ein JDK-Image mit den versteckten
  Referenztests kompiliert und prüft die vom Agenten implementierte Änderung im
  Ziel-Repo. Reproduzierbar containerisiert (Basis per Digest gepinnt), wie
  `doc-check`; der Referenztest steckt im Image, nie im Ziel-Repo.
- `Makefile` — die Eval-Ziele (`init`, `run`, `grade`, `image`, `verify`),
  getrennt vom Wurzel-`Makefile`, das nur dieses Regelwerk-Repo validiert.
- `consensus.sh` — führt die Verifikations-Ebenen (ausführbar, Judge-Panel,
  Signal-Assert) zu einem Verdikt mit Konfidenz zusammen (siehe Verifikation).

Jedes Szenario trägt außerdem eine `## Referenzlösung (Prüfmaßstab)` — objektive
Ja/Nein-Fakten, gegen die alle Ebenen messen.
- `init-fixture.sh` — setzt aus dem Regelwerk und `fixture/` ein Ziel-Repo im
  angegebenen Verzeichnis zusammen. Das Regelwerk landet gebündelt unter
  `.ddd-harness/` (dokumentierter Mindestumfang: `AGENTS.md` + `rules/` +
  `checklists/`), sodass die Projektwurzel sauber bleibt; eine schlanke
  Wurzel-`AGENTS.md` verweist auf `.ddd-harness/AGENTS.md`. Die ergänzenden
  Hilfen (`decisions/`, `patterns/`, `anti-patterns/`, `examples/`, `sources/`)
  sind optional über `--with-hilfen` — so lässt sich „mit/ohne Hilfen" als
  Eval-Variable vergleichen.

Layout des erzeugten Ziel-Repos:

```text
<ziel>/
  AGENTS.md              # schlanker Verweis auf .ddd-harness/AGENTS.md
  .ddd-harness/          # gebündeltes Regelwerk (interne Verweise bleiben gültig)
    AGENTS.md rules/ checklists/  [decisions/ patterns/ anti-patterns/ examples/ sources/]
  domain/ src/ BUILD.md  # das fiktive Projekt
```

## Ablauf

Der gesamte Ablauf ist über `make` steuerbar:

```sh
# 1. Ziel-Repo aufsetzen
make -C evals init DIR=/pfad/ziel                 # ARGS=--with-hilfen für die Hilfen

# 2. Agenten-Prompt zusammensetzen (Auftrag aus Szenario, Wrapper aus prompts/)
make -C evals run SCENARIO=scenarios/001-*.md DIR=/pfad/ziel OUT=/pfad/out/A-1.md
#   Ablationsarm ohne Regelwerk: ARM=ohne

# 3a. Analyse-Szenarien: Signal-Assert-Grading (+ LLM-Judge, s. u.)
make -C evals grade SCENARIO=scenarios/001-*.md OUT="/pfad/out/A-1.md /pfad/out/A-2.md"

# 3b. Code-Szenarien (z. B. 003): ausführbare Verifikation im Container
make -C evals image                               # einmalig das JDK-Image bauen
make -C evals verify DIR=/pfad/ziel SCENARIO=003  # compile + Referenztest -> PASS/FAIL
```

Die Eval-Ziele liegen bewusst in `evals/Makefile`, getrennt vom Wurzel-`Makefile`
(das nur dieses Regelwerk-Repo validiert). Die `SCENARIO=`-Pfade sind relativ zu
`evals/`, weil `make -C evals` dort ausgeführt wird.

Den `judge.md`-Prompt (Platzhalter `{{szenario}}`, `{{antworten}}`) füllt man mit
dem Szenariopfad und der Liste der Antwortdateien und gibt ihn einem separaten
Prüf-Agenten — er ist für semantische Fragen maßgeblich (siehe Grading).

## Szenario-Typen

1. **Falle / Verstoßerkennung** — fängt zu *schwache* Regeln (false negative).
2. **Readiness-Gating** — fehlende Fachregel ⇒ `analysis-only`, kein Erfinden.
3. **Gute Änderung** — korrekte DDD-Umsetzung inkl. passender Tests.
4. **Über-Anwendung** — fängt zu *aggressive* Regeln (false positive): simples
   CRUD darf **nicht** zu Aggregaten/Ereignissen aufgeblasen werden.

## Grading

- **Signal-Assert** (billig, halb-deterministisch): `grade.sh <szenario.md>
  <antwort> [...]` liest den ```grading-Block des Szenarios und prüft je Antwort,
  ob alle Pflicht-Signale vorkommen, kein verbotenes vorkommt und eine erlaubte
  Bereitschaft genannt ist. Mehrere Antwortdateien ⇒ Pass-Rate.
- **LLM-als-Judge**: Eine Rubrik bewertet Begründung und Codequalität robuster
  gegen die Formulierung.

Agenten sind nicht-deterministisch: jedes Szenario **N-mal** laufen lassen und
die **Pass-Rate** melden, nicht ein einzelnes Ergebnis.

### Grenzen des Signal-Assert (aus einem Ablationslauf)

Ein Lauf zu Szenario 001 (3× mit Regelwerk, 2× ohne, plus LLM-Judge) hat gezeigt:

- Signal-Assert ist zu grob für **semantische** Fragen: Ein Feldname wie
  `lieferantName` matcht auch, wenn ein Lesemodell-DTO ihn **außerhalb** des
  Aggregats korrekt verwendet (Falsch-negativ), und ein Substring wie `ready`
  matcht die zitierte Stufen-Skala statt der **deklarierten** Stufe
  (Falsch-positiv). Die eigentliche Einbettungsfrage entscheidet der Judge.
- `pflicht-any` (mindestens eine einschlägige Regel-ID) ist robuster als eine
  feste ID, weil verschiedene Läufe unterschiedliche, gleich gültige Regeln
  zitieren (`DDD-AGG-001` vs. `DDD-BC-001`).
- Der Judge bewertete alle fünf Antworten verhaltensseitig korrekt (mit
  Regelwerk 3/3, ohne 2/2): Ein starkes Basismodell trifft das Kernverhalten
  auch ohne Regelwerk. Der messbare Beitrag des Regelwerks lag in den
  Zusatzdimensionen — deklarierte Bereitschaft/Readiness-Gating, explizite
  Regel-ID-Nachvollziehbarkeit und das Verweigern der wörtlich
  grenzverletzenden Umsetzung. Aussagekräftiger werden dafür Szenarien, bei
  denen das Kernverhalten selbst kippt (002 Readiness-Gating, 004 Über-Anwendung).

### Wo das Regelwerk messbar wirkt (Ablation 002/004)

Ein Ablationslauf (je 3× mit / 3× ohne Regelwerk, 3-Judge-Panel + `consensus.sh`)
zeigt, dass der Effekt szenarioabhängig ist:

- **002 Readiness-Gating — starker Effekt.** Mit Regelwerk 3/3 korrekt
  (`analysis-only`), ohne Regelwerk 0/3: Die regellosen Läufe implementierten die
  in der Domänendoku bewusst offengelassene Zuteilungsregel (FIFO) als konkreten
  Vorschlag, statt zu gaten. Genau das verhindert `DDD-READY-001`.
- **004 Über-Anwendung — kein messbarer Effekt.** Mit und ohne Regelwerk je 3/3:
  Ein starkes Basismodell bläht ein triviales Notizfeld ohnehin nicht mit
  Ereignissen oder Aggregaten auf.

Lehre: Der Nutzen des Regelwerks liegt dort, wo das Basismodell ohne explizite
Leitplanke fehlgeht (eine fehlende Fachregel erfinden), nicht bei Aufgaben, die es
schon beherrscht. Aussagekräftige Szenarien zielen auf diese Lücke. (Alle Verdikte
kamen mit Konfidenz „hoch" — die Ebenen stimmten überein.)

## Verifikation (kombiniert)

Kein einzelnes Signal ist die Wahrheit. Das Verdikt entsteht durch **Triangulation**
dreier Ebenen gegen die Referenzrubrik des Szenarios:

1. **Ausführbare Wahrheit** (Ebene 1, maßgeblich wo vorhanden) — `make -C evals
   verify` kompiliert die vom Agenten implementierte Änderung gegen einen
   versteckten Referenztest. Objektiv, nur für code-erzeugende Szenarien.
2. **Referenzrubrik** (Ebene 2) — der Abschnitt „Referenzlösung (Prüfmaßstab)":
   objektive Ja/Nein-Fakten, gegen die Signal-Assert und Judges messen.
3. **Adversariales Judge-Panel** (Ebene 3) — mehrere unabhängige Judges
   (`prompts/judge.md`, mit Widerlegungsauftrag) bewerten dieselbe Antwort;
   die Mehrheit entscheidet, wo kein Test greift.

`consensus.sh` führt sie zusammen: der ausführbare Test ist maßgeblich, sonst die
Panel-Mehrheit; `grade.sh` (Signal-Assert) dient als Kreuzprüfung.

```sh
# je Antwort: ausführbar (bei Code-Szenarien) + N Judge-Stimmen + Signal-Assert
./evals/consensus.sh --exec PASS --judge PASS --judge PASS --judge FAIL --signal PASS
```

Stimmen alle vorhandenen Ebenen überein → Konfidenz **hoch**. Weichen sie ab →
**PRÜFEN** (Exit 3). Divergenzen sind kein Ärgernis, sondern der Prüfpfad — genau
dort steckt der Erkenntnisgewinn (so wurden die Signal-Assert-Schwächen gefunden).

## Warum außerhalb von `make test`

Eine Eval ruft ein LLM auf — nicht-deterministisch und nicht netzfrei. Sie
gehört daher nicht in die deterministische Suite. `evals/` ist in `.d-check.yml`
über `scan.ignore` von der Doku-Prüfung ausgenommen.
