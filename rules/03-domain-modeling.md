---
id: DDD-MOD-001
title: Das Fachliche vor der Technik modellieren
category: domain-modeling
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Das Fachliche vor der Technik modellieren

## Absicht

Stelle sicher, dass die Softwarestruktur fachliche Konzepte und Entscheidungen widerspiegelt.

## Regel

Der Agent MUSS Domänenkonzepte, Regeln und Arbeitsabläufe bestimmen, bevor er Frameworks, Schemas oder Transportmechanismen auswählt.

## Verbindliches Verhalten

- MUSS vom fachlichen Verhalten und von der Domänensprache ausgehen.
- MUSS Zustandsübergänge ausdrücklich modellieren.
- MUSS wichtige fachliche Regeln nahe bei den Daten darstellen, die sie bestimmen.
- MUSS technische Mechanismen austauschbar halten.

## Verbotenes Verhalten

- DARF NICHT die Domäne aus Datenbanktabellen entwerfen.
- DARF NICHT Controller, APIs oder Nachrichtenformate als Domänenmodell behandeln.
- DARF NICHT Domänenobjekte nach Framework-Konzepten benennen.

## Entscheidungskriterien

Diese Regel gilt immer dann, wenn eine Änderung fachliches Verhalten oder Domänenzustand betrifft.
Reine Infrastrukturwartung erfordert möglicherweise keine neue Domänenmodellierung.

## Prüfung

- Lässt sich das Verhalten erklären, ohne ein Framework zu erwähnen?
- Entspricht jeder wichtige Typ einem Domänenkonzept?
- Sind fachliche Regeln im Modell sichtbar?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-DDD-INTRO](../sources/references.md#ms-ddd-intro)
