---
id: DDD-UL-001
title: Eine Sprache je Bounded Context verwenden
category: ubiquitous-language
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Eine Sprache je Bounded Context verwenden

## Absicht

Halte die Terminologie zwischen Fachexperten, Dokumentation, Tests und Code konsistent.

## Regel

Jeder Begriff MUSS innerhalb eines Bounded Contexts genau eine ausdrückliche Bedeutung haben.

## Verbindliches Verhalten

- MUSS etablierte Domänenbegriffe in Namen und Tests wiederverwenden.
- MUSS neue Begriffe im Glossar des Kontexts festhalten.
- MUSS Synonyme bewusst auflösen.
- MUSS zulassen, dass dasselbe Wort in verschiedenen Kontexten unterschiedliche Bedeutungen hat.

## Verbotenes Verhalten

- DARF NICHT generische Namen einführen, wenn ein präziser Domänenbegriff existiert.
- DARF NICHT Infrastrukturvokabular für fachliche Konzepte verwenden.
- DARF NICHT für jeden Begriff eine unternehmensweit einheitliche Bedeutung annehmen.

## Entscheidungskriterien

Wende diese Regel auf öffentliche APIs, Domänentypen, Methoden, Ereignisse, Befehle, Tests und Dokumentation an.

## Prüfung

- Verwendet der Code die Sprache der Domäne?
- Ist jeder wichtige Begriff innerhalb seines Bounded Contexts definiert?
- Sind Synonyme oder mehrfach belegte Begriffe ausdrücklich gekennzeichnet?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-DOMAIN-ANALYSIS](../sources/references.md#ms-domain-analysis)
