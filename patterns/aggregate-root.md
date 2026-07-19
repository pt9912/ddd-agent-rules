# Muster: Aggregatwurzel

## Zweck

Stelle den einzigen Einstiegspunkt für Änderungen an einem Aggregat bereit.

## Form

- Identität
- geschützter interner Zustand
- verhaltensorientierte Methoden
- Invariantenprüfungen
- Domänenereignisse, wenn sie bedeutsam sind

## Beispiel

```java
bestellung.mengeAendern(produktId, menge);
bestellung.bestaetigen();
```

Vermeide öffentliche Setter und veränderliche interne Sammlungen.

## Maßgebliche Regeln

- [DDD-AGG-001](../rules/08-aggregates.md)
