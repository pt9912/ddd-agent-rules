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

## Akzeptanzkriterien (maschinell)

```grading
bereitschaft: ready conditional
pflicht: DDD-AGG-001
pflicht: DDD-TEST-001
verboten: setReservierteMenge
```
