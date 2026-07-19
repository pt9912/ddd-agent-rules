# Szenario 003 — Reservierung aufheben

**Typ:** Gute Änderung (korrekte DDD-Umsetzung inkl. Test).

## Aufgabe (Prompt an den Agenten)

> Füge eine Möglichkeit hinzu, eine bestehende Reservierung anhand ihrer Identität
> (`ReservierungId`) wieder aufzuheben, sodass die freigegebene Menge erneut
> reservierbar wird.

## Erwartetes Verhalten

Das Verhalten ist durch die vorhandenen Invarianten vollständig bestimmt: Die
benannte Reservierung wird entfernt, wodurch die reservierte Menge (Summe der
Reservierungen) sinkt und die freie Menge steigt (INV-LAG-1/2). Die Änderung
gehört auf die Aggregatwurzel `Lagerartikel` (z. B.
`reservierungAufheben(ReservierungId id)`), prüft ihre Eingaben (eine unbekannte
Reservierung wird abgelehnt) und wird durch einen Domänentest über beobachtbares
Verhalten abgesichert. Der Zustand wird nicht über einen Setter von außen
manipuliert.

## Geprüfter Fehlermodus

Der Agent umgeht die Aggregatwurzel (Setter/direkte Feldänderung) oder ergänzt
keinen Test für die betroffene Invariante.

## Referenzlösung (Prüfmaßstab)

Eine korrekte Antwort erfüllt:

- **[ja]** Eine Methode auf der Aggregatwurzel `Lagerartikel` (z. B. `reservierungAufheben(ReservierungId)`), die die benannte Reservierung entfernt.
- **[ja]** Invariante gewahrt: die reservierte Menge sinkt entsprechend; eine unbekannte `ReservierungId` wird abgelehnt.
- **[nein]** Zustandsänderung über einen Setter oder direkten Feldzugriff von außen.
- **[ja]** Ein Domänentest deckt das Verhalten ab.

Dieser Maßstab ist **ausführbar** geprüft: `evals/verify/003/` bzw.
`make -C evals verify DIR=<ziel> SCENARIO=003`.

## Akzeptanzkriterien (maschinell)

```grading
bereitschaft: ready conditional
pflicht: DDD-AGG-001
pflicht: DDD-TEST-001
```
