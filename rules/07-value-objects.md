---
id: DDD-VO-001
title: Wertobjekte für beschreibende Konzepte bevorzugen
category: value-object
priority: recommended
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Wertobjekte für beschreibende Konzepte bevorzugen

## Absicht

Stelle Konzepte dar, die vollständig durch ihre Werte bestimmt sind.

## Regel

Ein Wertobjekt SOLLTE unveränderlich sein und nach Wert verglichen werden.

## Empfohlenes Verhalten

- SOLLTE die Erzeugung validieren.
- SOLLTE Verhalten bei dem Wert platzieren, den es bestimmt.
- SOLLTE Wertobjekte, soweit angemessen, für Beträge, Bereiche, Adressen, Identifikatoren und Domänenmesswerte verwenden.

## Abgeratenes Verhalten

- SOLLTE NICHT ohne fachlichen Grund eine Identität hinzufügen.
- SOLLTE NICHT teilweise gültige Instanzen offenlegen.
- SOLLTE NICHT rohe primitive Werte als ausreichend für wichtige Domänenkonzepte behandeln.

## Entscheidungskriterien

Wähle ein Wertobjekt, wenn der Austausch gegen eine andere Instanz mit gleichen Werten semantisch folgenlos ist.

## Prüfung

- Wird das Konzept vollständig durch seine Werte beschrieben?
- Kann es unveränderlich sein?
- Beseitigt es die übermäßige Verwendung primitiver Werte?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-TACTICAL-DDD](../sources/references.md#ms-tactical-ddd)
