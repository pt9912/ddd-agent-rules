---
id: DDD-INT-001
title: Über Grenzen von Bounded Contexts hinweg übersetzen
category: context-integration
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Über Grenzen von Bounded Contexts hinweg übersetzen

## Absicht

Verhindere, dass fremde Modelle lokale Domänenkonzepte verunreinigen.

## Regel

Jede kontextübergreifende Interaktion MUSS eine ausdrückliche Beziehung und Übersetzungsrichtlinie haben.

## Verbindliches Verhalten

- MUSS Upstream-/Downstream-Rollen dokumentieren.
- MUSS eine Anti-Corruption Layer verwenden, wenn das externe Modell das lokale Modell nicht prägen soll.
- MUSS stabile Integrationsverträge veröffentlichen.
- MUSS Domänenereignisse intern halten, sofern sie nicht bewusst übersetzt werden.
- MUSS Commit-, Wiederholungs-, Reihenfolge- und Idempotenzsemantik für Integrationsnachrichten definieren, wenn diese das fachliche Verhalten beeinflussen.

## Verbotenes Verhalten

- DARF NICHT interne Entitätsklassen zwischen Kontexten teilen.
- DARF NICHT zulassen, dass entfernte APIs lokale Domänennamen vorgeben.
- DARF NICHT Integrationsnachrichten als lokale Aggregate behandeln.
- DARF NICHT eine noch nicht bestätigte lokale Zustandsänderung durch eine Integrationsnachricht offenlegen.

## Entscheidungskriterien

Wähle das Integrationsmuster anhand von Eigentümerschaft, Einfluss, Vertrauen und Änderungskontrolle.

## Prüfung

- Ist die Beziehung dokumentiert?
- Wo findet die Übersetzung statt?
- Welches Modell ist maßgeblich?
- Kann sich jede Seite unabhängig ändern?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [DDD-CREW-CONTEXT-MAPPING](../sources/references.md#ddd-crew-context-mapping)
