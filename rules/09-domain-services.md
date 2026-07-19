---
id: DDD-SVC-001
title: Domänendienste nur für Domänenoperationen ohne natürlichen Eigentümer verwenden
category: domain-service
priority: recommended
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Domänendienste nur für Domänenoperationen ohne natürlichen Eigentümer verwenden

## Absicht

Halte Domänenverhalten ausdrücklich, ohne es in eine ungeeignete Entität oder ein ungeeignetes Wertobjekt zu zwingen.

## Regel

Ein Domänendienst SOLLTE zustandsloses, konzeptübergreifendes Domänenverhalten enthalten, das keinen natürlichen Objekteigentümer hat.

## Empfohlenes Verhalten

- SOLLTE den Dienst in der Domänensprache benennen.
- SOLLTE ihn unabhängig von Transport und Persistenz halten.
- SOLLTE Domänenobjekte oder Werte statt Framework-Anfragetypen übergeben.

## Abgeratenes Verhalten

- SOLLTE NICHT die gesamte fachliche Logik in Dienste verschieben.
- SOLLTE NICHT einen Domänendienst als prozedurales Skript verwenden.
- SOLLTE NICHT Infrastrukturabhängigkeiten in den Domänendienst injizieren.

## Entscheidungskriterien

Verwende einen Domänendienst erst, nachdem bestätigt wurde, dass das Verhalten nicht natürlich zu einer Entität, einem Wertobjekt oder einem Aggregat gehört.

## Prüfung

- Warum kann kein Domänenobjekt dieses Verhalten besitzen?
- Ist das Verhalten tatsächlich fachlich?
- Ist der Dienst zustandslos?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-DDD-INTRO](../sources/references.md#ms-ddd-intro)
