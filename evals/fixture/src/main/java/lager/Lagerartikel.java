package lager;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Aggregatwurzel des Bounded Context "Lager".
 *
 * Schützt die Invarianten:
 *   INV-LAG-1: Summe der Reservierungen <= verfuegbareMenge
 *   INV-LAG-2: verfuegbareMenge >= 0 und jede Reservierungsmenge > 0
 *   INV-LAG-3: eine Reservierung wird nur bei genuegend freier Menge angenommen
 *
 * Reservierungen sind ueber ihre Identitaet (ReservierungId) unterscheidbar. Ein
 * Wareneingang erhoeht die verfuegbare Menge. Der Lieferant gehoert zu einem
 * fremden Bounded Context und wird ausschliesslich ueber seine Identitaet
 * referenziert.
 */
public final class Lagerartikel {

    private final LagerartikelId id;
    private final LieferantId lieferantId;
    private int verfuegbareMenge;
    private final List<Reservierung> reservierungen = new ArrayList<>();

    public Lagerartikel(LagerartikelId id, LieferantId lieferantId, int anfangsbestand) {
        this.id = Objects.requireNonNull(id, "id erforderlich");
        this.lieferantId = Objects.requireNonNull(lieferantId, "lieferantId erforderlich");
        if (anfangsbestand < 0) {
            throw new IllegalArgumentException("Anfangsbestand darf nicht negativ sein");
        }
        this.verfuegbareMenge = anfangsbestand;
    }

    /** Nimmt eine Reservierung nur an, wenn genuegend freie Menge vorhanden ist. */
    public ReservierungId reservieren(int menge) {
        if (menge <= 0) {
            throw new IllegalArgumentException("Reservierungsmenge muss positiv sein");
        }
        if (reservierteMenge() + menge > verfuegbareMenge) {
            throw new FachlicheAblehnung("Nicht genug freie Menge fuer die Reservierung");
        }
        Reservierung reservierung = new Reservierung(new ReservierungId(UUID.randomUUID()), menge);
        reservierungen.add(reservierung);
        return reservierung.id();
    }

    /** Verbucht einen Wareneingang; die verfuegbare Menge steigt. */
    public void wareneingangVerbuchen(int menge) {
        if (menge <= 0) {
            throw new IllegalArgumentException("Wareneingangsmenge muss positiv sein");
        }
        verfuegbareMenge += menge;
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
        return reservierungen.stream().mapToInt(Reservierung::menge).sum();
    }

    public int freieMenge() {
        return verfuegbareMenge - reservierteMenge();
    }

    /** Unveraenderliche Sicht auf die Reservierungen (nur zum Lesen). */
    public List<Reservierung> reservierungen() {
        return List.copyOf(reservierungen);
    }
}
