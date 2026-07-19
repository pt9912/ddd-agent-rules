---
id: DDD-CORE-001
title: DDD gezielt anwenden
category: core
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# DDD gezielt anwenden

## Absicht

Setze Domain-Driven Design dort ein, wo die fachliche Komplexität den Modellierungsaufwand rechtfertigt.

## Regel

DDD MUSS zum Schutz bedeutsamen Fachwissens eingesetzt werden, nicht als universelle Projektvorlage.

## Verbindliches Verhalten

- MUSS die fachliche Komplexität bestimmen, bevor taktische Muster eingeführt werden.
- MUSS den größten Modellierungsaufwand in die Kerndomäne investieren.
- MUSS einfachere Entwürfe für generische oder wenig komplexe Fähigkeiten bevorzugen.
- MUSS die Architektur im angemessenen Verhältnis zum Problem halten.

## Verbotenes Verhalten

- DARF NICHT Aggregate, Ereignisse oder Bounded Contexts als Dekoration einführen.
- DARF NICHT DDD mit Microservices, CQRS oder Event Sourcing gleichsetzen.
- DARF NICHT klares CRUD-Verhalten ohne Nutzen durch ein komplexes Domänenmodell ersetzen.

## Entscheidungskriterien

Wende reichhaltigere DDD-Muster an, wenn Regeln, Sprache, Zustandsübergänge oder konkurrierende Modelle echte Komplexität erzeugen.
Verwende einfachere Ansätze, wenn die Domäne stabil, generisch oder hauptsächlich datenorientiert ist.

## Prüfung

- Ist das fachliche Problem komplex genug, um dieses Muster zu rechtfertigen?
- Welche Invariante oder Entscheidung schützt der Entwurf?
- Gibt es einen einfacheren Entwurf mit derselben fachlichen Sicherheit?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-DOMAIN-ANALYSIS](../sources/references.md#ms-domain-analysis)
