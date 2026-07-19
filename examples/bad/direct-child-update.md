# Schlechtes Beispiel: Unmittelbare Änderung eines untergeordneten Objekts

```java
bestellpositionRepository.aktualisiereMenge(bestellpositionId, menge);
```

Probleme:

- umgeht die Aggregatwurzel
- kann Invarianten der Bestellung verletzen
- verbirgt die Transaktionsgrenze
- behandelt eine interne Entität als unabhängiges Aggregat

## Maßgebliche Regeln

- [DDD-AGG-001](../../rules/08-aggregates.md)
