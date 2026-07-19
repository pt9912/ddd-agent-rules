---
id: DDD-AGG-001
title: Aggregatgrenzen schützen
category: aggregate
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Aggregatgrenzen schützen

## Absicht

Halte fachliche Invarianten innerhalb einer ausdrücklichen Transaktionsgrenze konsistent.

## Regel

Jede Zustandsänderung innerhalb eines Aggregats MUSS über die Aggregatwurzel erfolgen.

## Verbindliches Verhalten

- MUSS die vom Aggregat geschützte Invariante definieren.
- MUSS das Aggregat klein halten.
- MUSS andere Aggregate über ihre Identität referenzieren.
- MUSS das Aggregat als eine Konsistenzeinheit persistieren.
- MUSS Eventual Consistency über Aggregatgrenzen hinweg verwenden, soweit dies angemessen ist.

## Verbotenes Verhalten

- DARF NICHT untergeordnete Entitäten unmittelbar aktualisieren.
- DARF NICHT veränderliche Sammlungen offenlegen.
- DARF NICHT Aggregate aus Datenbank-Navigationseigenschaften aufbauen.
- DARF NICHT standardmäßig nicht zusammengehörige Aggregate in eine Transaktion laden.

## Entscheidungskriterien

Verwende ein gemeinsames Aggregat, wenn sich mehrere Objekte zusammen ändern müssen, um eine unmittelbar geltende Invariante zu bewahren.
Fasse Objekte nicht allein deshalb zusammen, weil sie miteinander in Beziehung stehen.

## Prüfung

- Welche Invariante definiert die Grenze?
- Ist die Wurzel der einzige Einstiegspunkt für Änderungen?
- Können Teile einen unabhängigen Lebenszyklus haben?
- Sind externe Referenzen Identifikatoren?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-TACTICAL-DDD](../sources/references.md#ms-tactical-ddd)
