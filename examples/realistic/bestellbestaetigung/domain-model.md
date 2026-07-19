# Domänenmodell und Invarianten

## Wertobjekte

Wichtige Fachwerte werden nicht als unstrukturierte primitive Werte durchgereicht. Die Konstruktoren verhindern teilweise gültige Instanzen.

```java
public record Geld(BigDecimal betrag, Currency waehrung) {
    public Geld {
        Objects.requireNonNull(betrag);
        Objects.requireNonNull(waehrung);
    }

    public Geld addieren(Geld andererBetrag) {
        gleicheWaehrungSicherstellen(andererBetrag);
        return new Geld(betrag.add(andererBetrag.betrag), waehrung);
    }

    public Geld multiplizieren(int faktor) {
        if (faktor <= 0) throw new IllegalArgumentException("Menge muss positiv sein");
        return new Geld(betrag.multiply(BigDecimal.valueOf(faktor)), waehrung);
    }

    public boolean groesserAls(Geld andererBetrag) {
        gleicheWaehrungSicherstellen(andererBetrag);
        return betrag.compareTo(andererBetrag.betrag) > 0;
    }

    private void gleicheWaehrungSicherstellen(Geld andererBetrag) {
        if (!waehrung.equals(andererBetrag.waehrung)) {
            throw new FachlicheAblehnung("Währungen dürfen nicht gemischt werden");
        }
    }
}

public record Bestellposition(
        ProduktId produktId,
        int menge,
        Geld vereinbarterEinzelpreis) {
    public Bestellposition {
        Objects.requireNonNull(produktId);
        Objects.requireNonNull(vereinbarterEinzelpreis);
        if (menge <= 0) throw new IllegalArgumentException("Menge muss positiv sein");
        if (vereinbarterEinzelpreis.betrag().signum() < 0) {
            throw new IllegalArgumentException("Einzelpreis darf nicht negativ sein");
        }
    }

    public Geld zeilensumme() {
        return vereinbarterEinzelpreis.multiplizieren(menge);
    }
}
```

`Bestellfreigabe` ist ein fachlicher Nachweis, keine technische Benutzerrolle. Sie ist an genau eine Bestellung und einen genehmigten Höchstbetrag gebunden.

```java
public record Bestellfreigabe(
        BestellfreigabeId id,
        BestellungId bestellungId,
        Geld genehmigtBis) {
    public boolean deckt(BestellungId id, Geld gesamtbetrag) {
        return bestellungId.equals(id) && !gesamtbetrag.groesserAls(genehmigtBis);
    }
}

public record Bestellrichtlinie(Geld freigabegrenze) {
    public boolean benoetigtFreigabe(Geld gesamtbetrag) {
        return gesamtbetrag.groesserAls(freigabegrenze);
    }
}
```

## Aggregatwurzel

Nur `Bestellung` darf Positionen verändern und die Bestätigung durchführen. Der Aufrufer kann interne Sammlungen weder ersetzen noch verändern.

```java
public final class Bestellung {
    private final BestellungId id;
    private final KundenId kundenId;
    private final List<Bestellposition> positionen = new ArrayList<>();
    private final List<Domaenenereignis> ereignisse = new ArrayList<>();
    private Bestellstatus status = Bestellstatus.ENTWURF;
    private Lieferadresse lieferadresse;

    public void positionHinzufuegen(Bestellposition position) {
        entwurfSicherstellen();
        positionen.add(Objects.requireNonNull(position));
    }

    public void lieferadresseFestlegen(Lieferadresse adresse) {
        entwurfSicherstellen();
        lieferadresse = Objects.requireNonNull(adresse);
    }

    public void bestaetigen(
            Bestellrichtlinie richtlinie,
            Optional<Bestellfreigabe> freigabe,
            Instant bestaetigtAm) {
        entwurfSicherstellen();
        if (positionen.isEmpty()) throw new FachlicheAblehnung("Mindestens eine Position erforderlich");
        if (lieferadresse == null) throw new FachlicheAblehnung("Lieferadresse fehlt");

        Geld gesamtbetrag = gesamtbetrag();
        if (gesamtbetrag.betrag().signum() <= 0) {
            throw new FachlicheAblehnung("Gesamtbetrag muss positiv sein");
        }
        if (richtlinie.benoetigtFreigabe(gesamtbetrag)
                && freigabe.filter(f -> f.deckt(id, gesamtbetrag)).isEmpty()) {
            throw new FachlicheAblehnung("Passende Bestellfreigabe erforderlich");
        }

        status = Bestellstatus.BESTAETIGT;
        ereignisse.add(new BestellungBestaetigt(
                UUID.randomUUID(), id, kundenId, gesamtbetrag,
                lieferadresse, List.copyOf(positionen), bestaetigtAm));
    }

    public List<Domaenenereignis> ereignisseEntnehmen() {
        List<Domaenenereignis> ergebnis = List.copyOf(ereignisse);
        ereignisse.clear();
        return ergebnis;
    }

    public BestellungId id() {
        return id;
    }

    public Bestellstatus status() {
        return status;
    }

    private Geld gesamtbetrag() {
        return positionen.stream()
                .map(Bestellposition::zeilensumme)
                .reduce(Geld::addieren)
                .orElseThrow(() -> new FachlicheAblehnung("Mindestens eine Position erforderlich"));
    }

    private void entwurfSicherstellen() {
        if (status != Bestellstatus.ENTWURF) {
            throw new FachlicheAblehnung("Bestätigte Bestellung ist nicht mehr veränderbar");
        }
    }
}
```

Das Ereignis wird erst nach dem erfolgreichen Zustandsübergang erfasst. Es enthält lokale Domänentypen und bleibt deshalb innerhalb des Vertriebskontexts.

```java
public record BestellungBestaetigt(
        UUID ereignisId,
        BestellungId bestellungId,
        KundenId kundenId,
        Geld gesamtbetrag,
        Lieferadresse lieferadresse,
        List<Bestellposition> positionen,
        Instant bestaetigtAm) implements Domaenenereignis {}
```

## Getroffene Modellierungsentscheidungen

- Die Freigabeentscheidung liegt im Aggregat, weil sie von Bestellzustand, Bestellung und Gesamtbetrag abhängt.
- Produkt und Kunde werden nur über Identifikatoren referenziert; sie gehören nicht zur Konsistenzgrenze der Bestellung.
- Die vereinbarten Preise werden als Snapshot in den Positionen gehalten. Eine spätere Änderung im Produktkatalog verändert die bestätigte Bestellung nicht.
- Lagerbestand wird nicht synchron im Aggregat geschützt. Eine Reservierung wäre ein eigener Prozess außerhalb dieser unmittelbaren Bestätigungsinvariante.

## Maßgebliche Regeln

- [DDD-UL-001](../../../rules/04-ubiquitous-language.md)
- [DDD-VO-001](../../../rules/07-value-objects.md)
- [DDD-AGG-001](../../../rules/08-aggregates.md)
- [DDD-EVT-001](../../../rules/11-domain-events.md)
