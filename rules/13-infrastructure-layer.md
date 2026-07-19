---
id: DDD-INF-001
title: Infrastruktur außerhalb der Domäne halten
category: infrastructure
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Infrastruktur außerhalb der Domäne halten

## Absicht

Schütze das Domänenmodell vor technischen Implementierungsdetails.

## Regel

Die Domänenschicht DARF NICHT von Datenbank-, Messaging-, Transport- oder Framework-Implementierungen abhängen.

## Verbindliches Verhalten

- MUSS von Ports oder Abstraktionen abhängen.
- MUSS Persistenz- und Transportdarstellungen an Grenzen abbilden.
- MUSS Framework-Annotationen, soweit praktikabel, aus der Domäne heraushalten.
- MUSS Serialisierungs- und ORM-Belange isolieren.

## Verbotenes Verhalten

- DARF NICHT Infrastrukturpakete in Domänencode importieren.
- DARF NICHT ORM-Entitäten aus Repositories zurückgeben.
- DARF NICHT fachliche Regeln in Adaptern platzieren.
- DARF NICHT Domänenverhalten an einen Message Broker oder eine Datenbank koppeln.

## Entscheidungskriterien

Infrastruktur kann von Domänenabstraktionen abhängen. Die umgekehrte Abhängigkeit ist verboten.

## Prüfung

- Kann die Domäne ohne Infrastruktur getestet werden?
- Werden externe Schemas übersetzt?
- Beeinflusst der Austausch der Datenbank das Domänenverhalten?

## Quellen

- [MS-INFRA-PERSISTENCE](../sources/references.md#ms-infra-persistence)
- [MS-TACTICAL-DDD](../sources/references.md#ms-tactical-ddd)
