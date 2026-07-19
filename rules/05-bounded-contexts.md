---
id: DDD-BC-001
title: Autonomie von Bounded Contexts schützen
category: bounded-context
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Autonomie von Bounded Contexts schützen

## Absicht

Verhindere unbeabsichtigte Kopplung zwischen Modellen mit unterschiedlichen Bedeutungen oder Verantwortlichkeiten.

## Regel

Jeder Bounded Context MUSS sein Modell, seine Terminologie und seine fachlichen Regeln besitzen.

## Verbindliches Verhalten

- MUSS ausdrückliche Kontextgrenzen definieren.
- MUSS Konzepte an Kontextgrenzen übersetzen.
- MUSS Persistenz- und Domänentypen innerhalb des Kontexts halten.
- MUSS Upstream- und Downstream-Abhängigkeiten dokumentieren.

## Verbotenes Verhalten

- DARF NICHT standardmäßig Entitäten über mehrere Kontexte teilen.
- DARF NICHT ein einziges kanonisches Domänenmodell im gesamten System wiederverwenden.
- DARF NICHT einem anderen Kontext erlauben, internen Domänenzustand unmittelbar zu verändern.

## Entscheidungskriterien

Erstelle einen Bounded Context, wenn Terminologie, Regeln, Eigentümerschaft, Lebenszyklus oder Änderungstakt wesentlich voneinander abweichen.
Unterscheide dabei den Problemraum (Subdomänen wie Kern-, Unterstützungs- und generische Domäne) vom Lösungsraum (Bounded Contexts); eine Subdomäne kann durch einen oder mehrere Bounded Contexts umgesetzt werden.

## Prüfung

- Ist die Eigentümerschaft klar?
- Werden externe Konzepte übersetzt?
- Kann sich der Kontext weiterentwickeln, ohne jede interne Änderung abzustimmen?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-DOMAIN-ANALYSIS](../sources/references.md#ms-domain-analysis)
- [DDD-CREW-CONTEXT-MAPPING](../sources/references.md#ddd-crew-context-mapping)
