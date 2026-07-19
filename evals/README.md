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
- `scenarios/` — Akzeptanzszenarien (Aufgabe + Kriterien). Diese werden dem
  Agenten **nicht** ins Ziel-Repo gelegt; sie sind der Prüfmaßstab.
- `init-fixture.sh` — setzt aus dem Regelwerk und `fixture/` ein temporäres
  Ziel-Repo zusammen, exakt nach der dokumentierten Installation
  (`AGENTS.target.md` → `AGENTS.md`, `rules/` + `checklists/` + Hilfen unter
  denselben relativen Pfaden). Der Assemblierungsschritt testet damit nebenbei
  die Installationsanleitung.

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

- **Signal-Assert** (billig, halb-deterministisch): Der Agent gibt einen
  strukturierten Verdikt-Block mit Bereitschaftsstufe und Regel-IDs aus; man
  prüft, ob die erwarteten Regel-IDs vorkommen und die verbotenen fehlen.
- **LLM-als-Judge**: Eine Rubrik bewertet Begründung und Codequalität robuster
  gegen die Formulierung.

Agenten sind nicht-deterministisch: jedes Szenario **N-mal** laufen lassen und
die **Pass-Rate** melden, nicht ein einzelnes Ergebnis.

## Warum außerhalb von `make test`

Eine Eval ruft ein LLM auf — nicht-deterministisch und nicht netzfrei. Sie
gehört daher nicht in die deterministische Suite. `evals/` ist in `.d-check.yml`
über `scan.ignore` von der Doku-Prüfung ausgenommen.
