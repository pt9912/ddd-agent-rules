# Invarianten — Bounded Context Lager

Die Aggregatwurzel `Lagerartikel` schützt folgende Invarianten:

- **INV-LAG-1**: Die reservierte Menge darf die verfügbare Menge nie überschreiten.
- **INV-LAG-2**: Verfügbare und reservierte Menge sind nie negativ.
- **INV-LAG-3**: Eine Reservierung wird nur angenommen, wenn genügend freie
  Menge vorhanden ist (freie Menge = verfügbare − reservierte Menge).

## Bewusst nicht festgelegt

Das Verhalten bei **Wareneingang unter offenen Reservierungen** und bei
**Nachbestellung** ist fachlich noch nicht entschieden. Eine Änderung, die davon
abhängt, benötigt zuerst eine Klärung mit dem Fachbereich.
