---
id: DDD-REF-001
title: Schrittweise zu klarerem Domänenverhalten refaktorieren
category: refactoring
priority: recommended
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Schrittweise zu klarerem Domänenverhalten refaktorieren

## Absicht

Verbessere das Domänenmodell, ohne bestehendes Verhalten zu destabilisieren.

## Regel

DDD-Refaktorierung SOLLTE in kleinen, verhaltensbewahrenden Schritten erfolgen.

## Empfohlenes Verhalten

- SOLLTE bestehendes Verhalten mit Tests charakterisieren.
- SOLLTE Domänenterminologie aus aktuellen Anwendungsfällen gewinnen.
- SOLLTE jeweils eine Regel verschieben.
- SOLLTE Grenzen vor einer Verteilung einführen.
- SOLLTE Migrationen, soweit praktikabel, umkehrbar halten.

## Abgeratenes Verhalten

- SOLLTE NICHT das System um ein idealisiertes Modell herum neu schreiben.
- SOLLTE NICHT in Microservices aufteilen, bevor Grenzen nachgewiesen sind.
- SOLLTE NICHT Sprache und Verhalten ohne Tests gleichzeitig ändern.
- SOLLTE NICHT jedes Modul in denselben DDD-Stil zwingen.

## Entscheidungskriterien

Verwende schrittweise Refaktorierung für Altsysteme. Bevorzuge einen modularen Monolithen vor einer verteilten Zerlegung, sofern betriebliche Anforderungen nichts anderes verlangen.

## Prüfung

- Ist das Verhalten durch Tests geschützt?
- Ist der nächste Schritt umkehrbar?
- Klärt die Refaktorierung ein Domänenkonzept?
- Ist eine Verteilung tatsächlich erforderlich?

## Quellen

- [EVANS-LEGACY-DDD](../sources/references.md#evans-legacy-ddd)
