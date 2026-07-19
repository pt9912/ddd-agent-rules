package lager;

import java.util.UUID;

/**
 * Verstecktes Referenztest für Szenario 003 (Reservierung aufheben).
 *
 * Liegt bewusst NICHT im Fixture-Repo: Der Agent implementiert die Änderung im
 * Repo, dieser Test prüft sie objektiv gegen die Invarianten. Er wird von
 * evals/verify-exec bzw. dem Docker-Image zusammen mit den lager-Quellen des
 * Ziel-Repos kompiliert und ausgeführt (plain Java, kein Testframework).
 *
 * Erwartet eine Methode Lagerartikel.reservierungAufheben(ReservierungId id), die
 * die benannte Reservierung entfernt, die reservierte Menge entsprechend senkt und
 * eine unbekannte Identität ablehnt.
 */
public class ReservierungAufhebenPruefung {

    static int fehler = 0;

    static void pruefe(boolean bedingung, String was) {
        System.out.println((bedingung ? "ok:   " : "FAIL: ") + was);
        if (!bedingung) {
            fehler++;
        }
    }

    public static void main(String[] args) {
        LagerartikelId id = new LagerartikelId(UUID.randomUUID());
        LieferantId lieferant = new LieferantId(UUID.randomUUID());

        Lagerartikel a = new Lagerartikel(id, lieferant, 100);
        ReservierungId r1 = a.reservieren(30);
        a.reservieren(20);
        pruefe(a.reservierteMenge() == 50, "Vorbedingung: 50 reserviert (zwei Reservierungen)");

        a.reservierungAufheben(r1);
        pruefe(a.reservierteMenge() == 20, "nach Aufheben(r1): 20 reserviert");
        pruefe(a.freieMenge() == 80, "freie Menge = 80");

        boolean unbekanntAbgelehnt = false;
        try {
            a.reservierungAufheben(new ReservierungId(UUID.randomUUID()));
        } catch (RuntimeException e) {
            unbekanntAbgelehnt = true;
        }
        pruefe(unbekanntAbgelehnt, "Aufheben einer unbekannten ReservierungId wird abgelehnt");
        pruefe(a.reservierteMenge() == 20, "Zustand nach abgelehntem Aufheben unveraendert");

        boolean doppeltAbgelehnt = false;
        try {
            a.reservierungAufheben(r1);
        } catch (RuntimeException e) {
            doppeltAbgelehnt = true;
        }
        pruefe(doppeltAbgelehnt, "erneutes Aufheben derselben Reservierung wird abgelehnt");

        a.wareneingangVerbuchen(50);
        pruefe(a.verfuegbareMenge() == 150, "nach Wareneingang(50): verfuegbar 150");
        pruefe(a.freieMenge() == 130, "freie Menge = 130");

        if (fehler > 0) {
            System.out.println("VERIFIKATION FEHLGESCHLAGEN: " + fehler + " Fehler");
            System.exit(1);
        }
        System.out.println("VERIFIKATION OK");
    }
}
