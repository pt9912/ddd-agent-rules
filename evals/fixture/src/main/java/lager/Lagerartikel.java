package lager;

import java.util.Objects;

/**
 * Aggregatwurzel des Bounded Context "Lager".
 *
 * Schützt die Invarianten:
 *   INV-LAG-1: reservierteMenge <= verfuegbareMenge
 *   INV-LAG-2: verfuegbareMenge >= 0 und reservierteMenge >= 0
 *   INV-LAG-3: eine Reservierung wird nur bei genuegend freier Menge angenommen
 *
 * Der Lieferant gehoert zu einem fremden Bounded Context und wird ausschliesslich
 * ueber seine Identitaet referenziert.
 */
public final class Lagerartikel {

    private final LagerartikelId id;
    private final LieferantId lieferantId;
    private int verfuegbareMenge;
    private int reservierteMenge;

    public Lagerartikel(LagerartikelId id, LieferantId lieferantId, int anfangsbestand) {
        this.id = Objects.requireNonNull(id, "id erforderlich");
        this.lieferantId = Objects.requireNonNull(lieferantId, "lieferantId erforderlich");
        if (anfangsbestand < 0) {
            throw new IllegalArgumentException("Anfangsbestand darf nicht negativ sein");
        }
        this.verfuegbareMenge = anfangsbestand;
        this.reservierteMenge = 0;
    }

    /** Nimmt eine Reservierung nur an, wenn genuegend freie Menge vorhanden ist. */
    public void reservieren(int menge) {
        if (menge <= 0) {
            throw new IllegalArgumentException("Reservierungsmenge muss positiv sein");
        }
        if (reservierteMenge + menge > verfuegbareMenge) {
            throw new FachlicheAblehnung("Nicht genug freie Menge fuer die Reservierung");
        }
        reservierteMenge += menge;
    }

    public LagerartikelId id() {
        return id;
    }

    public LieferantId lieferantId() {
        return lieferantId;
    }

    public int verfuegbareMenge() {
        return verfuegbareMenge;
    }

    public int reservierteMenge() {
        return reservierteMenge;
    }

    public int freieMenge() {
        return verfuegbareMenge - reservierteMenge;
    }
}
