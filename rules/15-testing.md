---
id: DDD-TEST-001
title: Fachliches Verhalten an der Domänengrenze testen
category: testing
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Fachliches Verhalten an der Domänengrenze testen

## Absicht

Prüfe Domänenentscheidungen und Invarianten unabhängig von der Infrastruktur.

## Regel

Betroffenes fachliches Verhalten MUSS durch Tests abgedeckt sein. Bei Implementierung oder Refaktorierung MUSS der Agent diese Tests ergänzen oder aktualisieren. Bei einer reinen Prüfaufgabe MUSS der Agent fehlende und erforderliche Tests melden, DARF aber NICHT Dateien verändern, sofern der Benutzer nicht ebenfalls Änderungen verlangt.

## Verbindliches Verhalten

- MUSS Domänenterminologie in Testnamen verwenden.
- MUSS die Validierung von Wertobjekten testen.
- MUSS Aggregatverhalten ohne Datenbank testen.
- MUSS bei Implementierung oder Refaktorierung Integrationstests für Adapter und Kontextgrenzen ergänzen.
- MUSS die Idempotenz von Nachrichten-Handlern prüfen, soweit dies relevant ist.
- MUSS Rollback-, Commit- und Veröffentlichungsfehler testen, wenn Integrationsnachrichten auf Domänenänderungen folgen.

## Verbotenes Verhalten

- DARF NICHT nur Getter und Setter testen.
- DARF NICHT ausschließlich auf End-to-End-Tests vertrauen.
- DARF NICHT das Domänenmodell mocken.
- DARF NICHT Domänentests an ORM-Verhalten koppeln.
- DARF NICHT das geprüfte Projekt während einer reinen Prüfaufgabe ohne ausdrückliche Erlaubnis verändern.

## Entscheidungskriterien

Bevorzuge schnelle Domänentests für fachliche Regeln und fokussierte Integrationstests für Infrastruktur.

## Prüfung

- Welche Invariante wird nachgewiesen?
- Wird das Fehlerverhalten getestet?
- Kann der Test ohne Infrastruktur laufen?
- Sind Übersetzungen an Grenzen abgedeckt?

## Quellen

- [MS-DOMAIN-VALIDATION](../sources/references.md#ms-domain-validation)
- [MS-DOMAIN-EVENTS](../sources/references.md#ms-domain-events)
