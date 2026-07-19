package lager;

import java.util.Optional;
import java.util.UUID;

/** Identität eines Lagerartikels. */
record LagerartikelId(UUID wert) {
}

/** Identität eines Lieferanten aus dem fremden Bounded Context Einkauf. */
record LieferantId(UUID wert) {
}

/** Fachliche Ablehnung einer Domänenoperation (kein technischer Fehler). */
class FachlicheAblehnung extends RuntimeException {
    FachlicheAblehnung(String nachricht) {
        super(nachricht);
    }
}

/** Domänen-Port; die Implementierung lebt in der Infrastruktur. */
interface LagerartikelRepository {
    Optional<Lagerartikel> finde(LagerartikelId id);

    void speichern(Lagerartikel artikel);
}
