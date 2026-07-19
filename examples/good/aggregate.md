# Gutes Beispiel: Aggregatänderung

```java
Bestellung bestellung = bestellungsRepository.laden(bestellungsId);
bestellung.mengeAendern(produktId, menge);
bestellungsRepository.speichern(bestellung);
```

Warum:

- die Änderung erfolgt über die Aggregatwurzel
- das Aggregat schützt die Mengenregeln
- die Persistenz ist hinter einem Repository verborgen

## Maßgebliche Regeln

- [DDD-AGG-001](../../rules/08-aggregates.md)
- [DDD-REP-001](../../rules/10-repositories.md)
