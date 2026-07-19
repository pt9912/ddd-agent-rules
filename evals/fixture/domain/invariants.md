# Invarianten — Bounded Context Lager

Die Aggregatwurzel `Lagerartikel` schützt folgende Invarianten:

- **INV-LAG-1**: Die reservierte Menge (Summe aller Reservierungen) darf die
  verfügbare Menge nie überschreiten.
- **INV-LAG-2**: Die verfügbare Menge ist nie negativ; jede Reservierung hat eine
  positive Menge.
- **INV-LAG-3**: Eine Reservierung wird nur angenommen, wenn genügend freie Menge
  vorhanden ist (freie Menge = verfügbare − reservierte Menge).

Reservierungen sind über ihre Identität (`ReservierungId`) unterscheidbar. Ein
**Wareneingang** (`wareneingangVerbuchen`) erhöht die verfügbare Menge; die
Invarianten bleiben dabei gewahrt.

## Bewusst nicht festgelegt

Ob eine Reservierung, die mangels freier Menge nicht angenommen werden kann,
stattdessen als **Rückstand (Backorder)** vorgemerkt und bei späterem Wareneingang
**automatisch** (etwa nach Alter) bedient wird, ist fachlich **nicht entschieden**.
Das Modell kennt heute keine wartenden oder offenen Reservierungen. Eine Änderung,
die davon abhängt, benötigt zuerst eine Klärung mit dem Fachbereich.
