package lager;

import java.util.UUID;

/**
 * Verstecktes Referenztest für Szenario 003 (Reservierung aufheben).
 *
 * Liegt bewusst NICHT im Fixture-Repo: Der Agent implementiert die Änderung im
 * Repo, dieser Test prüft sie objektiv gegen die Invarianten. Er wird von
 * evals/verify-exec.sh zusammen mit den lager-Quellen des Ziel-Repos kompiliert
 * und ausgeführt (plain Java, kein Testframework).
 *
 * Erwartet eine Methode Lagerartikel.reservierungAufheben(int menge), die die
 * reservierte Menge senkt, INV-LAG-2 wahrt (nie negativ) und nicht-positive
 * Mengen sowie ein Aufheben über die reservierte Menge hinaus ablehnt.
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
        a.reservieren(30);
        pruefe(a.reservierteMenge() == 30, "Vorbedingung: 30 reserviert");

        a.reservierungAufheben(10);
        pruefe(a.reservierteMenge() == 20, "nach Aufheben(10): 20 reserviert");
        pruefe(a.freieMenge() == 80, "freie Menge = 80");

        boolean ueberMengeAbgelehnt = false;
        try {
            a.reservierungAufheben(999);
        } catch (RuntimeException e) {
            ueberMengeAbgelehnt = true;
        }
        pruefe(ueberMengeAbgelehnt, "Aufheben über reservierte Menge abgelehnt (INV-LAG-2)");
        pruefe(a.reservierteMenge() == 20, "Zustand nach Ablehnung unverändert");

        boolean nichtPositivAbgelehnt = false;
        try {
            a.reservierungAufheben(0);
        } catch (RuntimeException e) {
            nichtPositivAbgelehnt = true;
        }
        pruefe(nichtPositivAbgelehnt, "Aufheben(0) abgelehnt");

        if (fehler > 0) {
            System.out.println("VERIFIKATION FEHLGESCHLAGEN: " + fehler + " Fehler");
            System.exit(1);
        }
        System.out.println("VERIFIKATION OK");
    }
}
