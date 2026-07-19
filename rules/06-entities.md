---
id: DDD-ENT-001
title: Entitäten für Identität und Lebenszyklus verwenden
category: entity
priority: recommended
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Entitäten für Identität und Lebenszyklus verwenden

## Absicht

Stelle Domänenkonzepte dar, deren Identität stabil bleibt, während sich Attribute ändern.

## Regel

Eine Entität SOLLTE nur verwendet werden, wenn die Domäne eine zeitübergreifende Identität benötigt.

## Empfohlenes Verhalten

- SOLLTE eine ausdrückliche Identitätssemantik definieren.
- SOLLTE gültige Lebenszyklusübergänge schützen.
- SOLLTE Gleichheit, soweit angemessen, von veränderlichen Attributen trennen.

## Abgeratenes Verhalten

- SOLLTE NICHT Entitäten für jede persistierte Zeile verwenden.
- SOLLTE NICHT Entitäten nur anhand aller aktuellen Felder vergleichen.
- SOLLTE NICHT uneingeschränkte Setter für den Lebenszykluszustand offenlegen.

## Entscheidungskriterien

Wähle eine Entität, wenn die Domäne danach fragt, ob zwei Instanzen trotz geänderter Werte dasselbe fachliche Objekt sind.

## Prüfung

- Ist die Identität fachlich bedeutsam?
- Hat das Konzept einen Lebenszyklus?
- Werden Übergänge durch Verhalten geschützt?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-TACTICAL-DDD](../sources/references.md#ms-tactical-ddd)
