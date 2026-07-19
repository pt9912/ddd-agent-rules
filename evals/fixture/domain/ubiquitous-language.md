# Ubiquitäre Sprache — Bounded Context Lager

Dieser Kontext verwaltet den Warenbestand. Er entscheidet, ob und in welcher
Menge Ware reserviert werden kann.

| Begriff | Bedeutung |
| --- | --- |
| **Lagerartikel** | Ein im Lager geführter Artikel mit Bestand. Aggregatwurzel dieses Kontexts. |
| **verfügbare Menge** | Wie viel eines Lagerartikels physisch im Lager liegt. |
| **reservierte Menge** | Wie viel der verfügbaren Menge bereits zugesagt ist (Summe der Reservierungen). |
| **freie Menge** | Verfügbare Menge abzüglich reservierter Menge. |
| **Reservierung** | Eine verbindliche Zusage einer Menge für einen Auftrag, über eine `ReservierungId` unterscheidbar. |
| **Wareneingang** | Zugang von Ware, der die verfügbare Menge erhöht. |
| **Lieferant** | Wer den Artikel liefert. Gehört zum **fremden** Bounded Context *Einkauf* und wird hier nur über seine Identität (`LieferantId`) referenziert. |

Der Lieferant ist ein eigenständiges Aggregat eines anderen Kontexts. Der
Lagerkontext kennt nur dessen Identität, nicht dessen inneres Modell.
