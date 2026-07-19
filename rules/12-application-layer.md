---
id: DDD-APP-001
title: Anwendungsdienste schlank halten
category: application-layer
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Anwendungsdienste schlank halten

## Absicht

Koordiniere Anwendungsfälle, ohne zentrale fachliche Entscheidungen zu besitzen.

## Regel

Die Anwendungsschicht MUSS Domänenobjekte und Infrastruktur-Ports orchestrieren, DARF aber NICHT zum hauptsächlichen Ort von Domänenregeln werden.

## Verbindliches Verhalten

- MUSS Aggregate über domänenorientierte Ports laden.
- MUSS Domänenverhalten aufrufen, statt Domänenzustand zu manipulieren.
- MUSS Repositories und Transaktionsgrenzen koordinieren.
- MUSS ausgehende Integrationsnachrichten mit der fachlichen Transaktion persistieren, wenn zuverlässige Zustellung erforderlich ist.
- MUSS Integrationsnachrichten erst nach dem Commit veröffentlichen oder an einen transaktionalen Outbox-Publisher übergeben.
- MUSS Authentifizierung, grobe Zugriffskontrolle und die Reihenfolge des Anwendungsfalls durchsetzen.
- MUSS domänenrelevante Akteurs- oder Berechtigungsinformationen an die Domäne übergeben, wenn die Autorisierung vom fachlichen Zustand oder von fachlichen Richtlinien abhängt.

## Verbotenes Verhalten

- DARF NICHT Aggregatinvarianten in Handlern implementieren.
- DARF NICHT Entitätszustand unmittelbar manipulieren.
- DARF NICHT Framework-DTOs in die Domäne einbetten.
- DARF NICHT Domänenentscheidungen über mehrere Anwendungsfälle duplizieren.
- DARF NICHT zustandsabhängige fachliche Autorisierung ausschließlich in einem Anwendungs-Handler belassen.
- DARF NICHT eine Integrationsnachricht vor dem Commit der auslösenden Transaktion veröffentlichen.

## Entscheidungskriterien

Verwende Anwendungsdienste für Orchestrierung, Authentifizierung und Zugriffskontrolle auf Anwendungsfälle. Verschiebe zustandsabhängige Berechtigungen und andere fachliche Entscheidungen in das Domänenmodell.

## Prüfung

- Könnte diese Regel auf einem Domänenobjekt ausgedrückt werden?
- Koordiniert der Dienst, statt zu entscheiden?
- Sind Domäneninvarianten auch ohne den Handler geschützt?
- Ist eine fachliche Berechtigung über jeden Anwendungseinstiegspunkt geschützt?
- Ist die Integrationsveröffentlichung mit dem Transaktions-Commit konsistent?

## Quellen

- [MS-DDD-INTRO](../sources/references.md#ms-ddd-intro)
- [MS-TACTICAL-DDD](../sources/references.md#ms-tactical-ddd)
