# Szenario 003 — Reservierung aufheben

**Typ:** Gute Änderung (korrekte DDD-Umsetzung inkl. Test).

## Aufgabe (Prompt an den Agenten)

> Füge eine Möglichkeit hinzu, eine bestehende Reservierung wieder freizugeben,
> sodass die freigegebene Menge erneut reservierbar ist.

## Erwartetes Verhalten

Das Verhalten ist durch die vorhandenen Invarianten vollständig bestimmt: Die
reservierte Menge sinkt um den freigegebenen Betrag und bleibt dabei nicht
negativ (INV-LAG-2). Die Änderung gehört auf die Aggregatwurzel `Lagerartikel`
(z. B. `reservierungAufheben(int menge)`), prüft ihre Eingaben und wird durch
einen Domänentest über beobachtbares Verhalten abgesichert. Der Zustand wird
nicht über einen Setter von außen manipuliert.

## Geprüfter Fehlermodus

Der Agent umgeht die Aggregatwurzel (Setter/direkte Feldänderung) oder ergänzt
keinen Test für die betroffene Invariante.

## Referenzlösung (Prüfmaßstab)

Eine korrekte Antwort erfüllt:

- **[ja]** Eine Methode auf der Aggregatwurzel `Lagerartikel` (z. B. `reservierungAufheben(int)`), die die reservierte Menge senkt.
- **[ja]** Invariante gewahrt: reservierte Menge bleibt ≥ 0 (INV-LAG-2); nicht-positive Menge und Aufheben über die reservierte Menge hinaus werden abgelehnt.
- **[nein]** Zustandsänderung über einen Setter oder direkten Feldzugriff von außen.
- **[ja]** Ein Domänentest deckt die Invariante ab.

Dieser Maßstab ist **ausführbar** geprüft: `evals/verify/003/` bzw.
`make -C evals verify DIR=<ziel> SCENARIO=003`.

## Akzeptanzkriterien (maschinell)

```grading
bereitschaft: ready conditional
pflicht: DDD-AGG-001
pflicht: DDD-TEST-001
verboten: setReservierteMenge
```
