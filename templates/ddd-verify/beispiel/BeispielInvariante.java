// Beispiel-Invariantentest — ersetze ihn durch Prüfungen deiner Aggregatwurzeln.
//
// Konvention: public static void main; bei Invariantenverletzung mit Exit != 0
// enden (oder eine Ausnahme werfen). Der Test wird zusammen mit src/main/java
// kompiliert und darf die Domänentypen des Repos verwenden.
public class BeispielInvariante {
    public static void main(String[] args) {
        // Hier die Invarianten einer Aggregatwurzel prüfen. Platzhalter:
        if (1 + 1 != 2) {
            throw new AssertionError("Invariante verletzt");
        }
        System.out.println("ok: Beispielinvariante (ersetzen)");
    }
}
