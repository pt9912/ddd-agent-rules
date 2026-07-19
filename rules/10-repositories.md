---
id: DDD-REP-001
title: Repositories für die Persistenz von Aggregaten verwenden
category: repository
priority: recommended
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Repositories für die Persistenz von Aggregaten verwenden

## Absicht

Stelle einen sammlungsähnlichen Zugriff auf Aggregatwurzeln bereit und verberge dabei Persistenzdetails.

## Regel

Ein Repository SOLLTE um eine Aggregatwurzel und fachliche Anforderungen herum definiert werden.

## Empfohlenes Verhalten

- SOLLTE Domänenaggregate zurückgeben.
- SOLLTE bei Bedarf domänenspezifische Abfragen anbieten.
- SOLLTE Repository-Schnittstellen innerhalb oder nahe der Domänen-/Anwendungsgrenze halten.
- SOLLTE sie in der Infrastruktur implementieren.
- SOLLTE beim Speichern einer Aggregatwurzel optimistische Nebenläufigkeitskontrolle über eine Version durchsetzen.

## Abgeratenes Verhalten

- SOLLTE NICHT für jede Entität ein Repository erstellen.
- SOLLTE NICHT ORM-Abfrage-APIs gegenüber der Domäne offenlegen.
- SOLLTE NICHT ein generisches Repository als Standardabstraktion verwenden.
- SOLLTE NICHT aggregatübergreifende fachliche Transaktionen innerhalb von Repositories ausführen.

## Entscheidungskriterien

Verwende Repositories für persistierte Aggregatwurzeln. Verwende dedizierte Lesemodelle für komplexe Abfragen.

## Prüfung

- Arbeitet das Repository mit einer Aggregatwurzel?
- Sind die Abfrageanforderungen domänenspezifisch?
- Ist die Persistenz vor der Domäne verborgen?
- Werden gleichzeitige Änderungen an derselben Aggregatwurzel erkannt?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-TACTICAL-DDD](../sources/references.md#ms-tactical-ddd)
