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

```sh
# 1. Ziel-Repo aufsetzen (frisches Temp-Verzeichnis)
./evals/init-fixture.sh            # oder: make eval-init

# 2. Einen Code-Agenten mit Arbeitsverzeichnis = Ziel-Repo starten
#    und die "Aufgabe" eines Szenarios als Prompt geben.

# 3. Die Antwort gegen die Akzeptanzkriterien des Szenarios graden.
```

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

## Warum außerhalb von `make test`

Eine Eval ruft ein LLM auf — nicht-deterministisch und nicht netzfrei. Sie
gehört daher nicht in die deterministische Suite. `evals/` ist in `.d-check.yml`
über `scan.ignore` von der Doku-Prüfung ausgenommen.
