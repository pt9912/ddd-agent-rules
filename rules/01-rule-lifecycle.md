---
id: DDD-RLC-001
title: Den Lebenszyklus von DDD-Regeln ausdrücklich steuern
category: rule-lifecycle
priority: mandatory
status: active
applies_to:
  - rule-authoring
  - rule-review
  - refactoring
---

# Den Lebenszyklus von DDD-Regeln ausdrücklich steuern

## Absicht

Mache die fachliche Gültigkeit jeder DDD-Regel sichtbar, überprüfbar und unabhängig vom Zustand des Projekts.

Der DDD-Regellebenszyklus ist unabhängig vom [Projektlebenszyklus](../docs/projektlebenszyklus.md): Ein Projekt kann veröffentlicht sein und dennoch Regeln im Entwurf enthalten; eine Regel kann abgelöst werden, ohne dass das Projekt archiviert wird.

## Regel

Der Status jeder DDD-Regel MUSS ausdrücklich im Front Matter stehen und darf sich nur durch einen dokumentierten, validierten Übergang ändern.

## Verbindliches Verhalten

- MUSS für jede Regel genau einen zulässigen `status` angeben.
- MUSS den Status prüfen, bevor eine Regel normativ angewendet wird.
- MUSS Statusübergänge im Änderungsprotokoll dokumentieren.
- MUSS bei `superseded` mit `superseded_by` auf genau eine vorhandene Nachfolgeregel verweisen.
- MUSS Regel-ID und Historie über Statuswechsel hinweg stabil halten.
- MUSS Projektzustand und Regelstatus als unabhängige Zustandsmodelle behandeln.

## Verbotenes Verhalten

- DARF NICHT Regeln mit `draft`, `superseded` oder `retired` als aktive Vorgaben durchsetzen.
- DARF NICHT einen Projekt-Release als stillschweigenden Regelstatuswechsel behandeln.
- DARF NICHT eine Regel ohne dokumentierte fachliche Entscheidung reaktivieren.
- DARF NICHT eine abgelöste Regel auf sich selbst oder eine unbekannte Regel-ID verweisen lassen.
- DARF NICHT die Historie einer Regel durch Vergabe einer neuen ID für denselben fachlichen Regelinhalt verbergen.

## Entscheidungskriterien

### Statuswerte

| Status | Bedeutung | Wirkung für Agenten |
| --- | --- | --- |
| `draft` | Die Regel ist ein Entwurf und noch nicht freigegeben. | Nur als Diskussionsgrundlage verwenden; nicht als normativ durchsetzen. |
| `active` | Die Regel ist freigegeben. | Gemäß `priority` anwenden und Verstöße melden. |
| `deprecated` | Die Regel gilt noch für bestehendes Verhalten, soll aber nicht mehr neu eingeführt werden. | Bestehendes Verhalten bewahren, für neue Entscheidungen den dokumentierten Nachfolger oder die Migrationsrichtung bevorzugen. |
| `superseded` | Eine andere Regel hat diese Regel fachlich ersetzt. | Nicht mehr normativ anwenden; `superseded_by` folgen. |
| `retired` | Die Regel ist nur noch historisch relevant und hat keinen aktiven Nachfolger im Regelsatz. | Nicht für aktuelle Entscheidungen laden oder durchsetzen. |

### Zulässige Übergänge

```text
draft → active → deprecated → superseded → retired
  │       │            └────────────────────→ retired
  │       └────────────────→ superseded
  └────────────────→ retired
```

Ein Entwurf, der ohne Freigabe verworfen wird, kann unmittelbar nach `retired` übergehen; er hatte nie den Status `active` und schützt daher kein bestehendes Verhalten.

Eine Rückkehr von `deprecated`, `superseded` oder `retired` nach `active` ist nur mit einer ausdrücklichen fachlichen Entscheidung, einer Begründung im Änderungsprotokoll und vollständiger erneuter Validierung zulässig.

### Metadaten

Jede Regel enthält mindestens:

```yaml
id: DDD-...
priority: mandatory | recommended | contextual
status: draft | active | deprecated | superseded | retired
```

Eine Regel mit `status: superseded` enthält zusätzlich:

```yaml
superseded_by: DDD-...
```

### Aktivierung

Eine Regel kann von `draft` nach `active` wechseln, wenn:

- Bounded Context, Domänenkonzept und geschützte Invariante benannt sind,
- normative Modalität und Priorität konsistent sind,
- Beispiele, Gegenbeispiele oder Entscheidungskriterien die Anwendung prüfbar machen,
- Quellen nachvollziehbar sind und
- Validator, Richtlinienvertrag und d-check erfolgreich sind.

### Veraltung und Ablösung

Eine Regel kann von `active` nach `deprecated` wechseln, wenn Grund und Migrationsrichtung dokumentiert sind und bestehendes fachliches Verhalten geschützt bleibt.

Eine Regel kann nach `superseded` oder `retired` wechseln, wenn sie nicht mehr als aktuelle Handlungsanweisung verwendet wird, Verweise auf den Nachfolger führen oder die ersatzlose Entfernung erklären und der Übergang im Änderungsprotokoll steht.

## Aktueller Bestand

Alle Regeln unter `rules/` haben derzeit den Status `active`.

## Prüfung

- Trägt jede Regel genau einen gültigen Status?
- Entspricht die normative Behandlung dem Status der Regel?
- Ist jeder Übergang fachlich begründet und im Änderungsprotokoll dokumentiert?
- Verweist jede abgelöste Regel auf genau einen vorhandenen Nachfolger?
- Bleiben Projektzustand und Regelstatus unabhängig voneinander?

## Quellen

- [PROJECT-RULE-GOVERNANCE](../sources/references.md#project-rule-governance)
