# Gutes Beispiel: Kontextspezifisches Wertobjekt

In einem Vertriebskontext ist ein `Preis` als nicht negativer Betrag definiert. Andere Konzepte wie Kontosalden oder Korrekturen können berechtigterweise negative Geldwerte verwenden und sollten diese Invariante nicht unbesehen wiederverwenden.

```java
public record Preis(BigDecimal betrag, Currency waehrung) {
    public Preis {
        Objects.requireNonNull(betrag, "Betrag erforderlich");
        Objects.requireNonNull(waehrung, "Währung erforderlich");
        if (betrag.signum() < 0) {
            throw new IllegalArgumentException("Preis darf nicht negativ sein");
        }
    }
}
```

Warum:

- der Vertriebskontext und der Begriff `Preis` machen die Invariante ausdrücklich
- Werte beschreiben das Konzept vollständig
- die Erzeugung schützt die Invariante des nicht negativen Preises
- der Typ beseitigt die übermäßige Verwendung primitiver Werte

Erforderliche Tests:

- Preise von null und positive Preise können erzeugt werden
- ein negativer Preis wird abgelehnt
- negative Salden oder Korrekturen bleiben durch eigene Domänenkonzepte darstellbar

## Maßgebliche Regeln

- [DDD-UL-001](../../rules/04-ubiquitous-language.md)
- [DDD-VO-001](../../rules/07-value-objects.md)
