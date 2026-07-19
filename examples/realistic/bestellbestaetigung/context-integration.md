# Kontextintegration und Zustellung

## Übersetzung am Ausgang

`BestellungBestaetigt` ist ein internes Domänenereignis. Ein Mapper an der Grenze des Vertriebskontexts übersetzt es in einen stabilen, serialisierbaren Vertrag. Weder `Bestellung` noch `Bestellposition` werden nach außen gegeben.

```json
{
  "type": "sales.order-confirmed.v1",
  "eventId": "5a31ca27-0d23-4af6-a420-d43cbb8dc40f",
  "orderId": "ORD-2026-0042",
  "customerId": "CUS-4711",
  "confirmedAt": "2026-07-19T10:15:00Z",
  "currency": "EUR",
  "total": "12450.00",
  "deliveryAddress": {
    "recipient": "Beispiel GmbH",
    "street": "Musterweg 7",
    "postalCode": "50667",
    "city": "Köln",
    "country": "DE"
  },
  "lines": [
    {
      "productId": "PRD-1000",
      "quantity": 5
    }
  ]
}
```

Der Vertrag enthält nur die für Fulfillment benötigten, bestätigten Tatsachen. Interne Freigaben, Preise je Position und Vertriebsstatus bleiben verborgen. Eine inkompatible Vertragsänderung erfordert eine neue Schemaversion.

## Outbox-Zustellung

Der Outbox-Eintrag enthält mindestens:

- eine global eindeutige `eventId`
- den Vertragstyp einschließlich Version
- die serialisierte Nutzlast
- Erzeugungszeitpunkt und Zustellstatus
- Anzahl und Zeitpunkt fehlgeschlagener Versuche

Der Publisher darf Einträge wiederholt senden. Er verwendet exponentielle Wiederholung und verschiebt dauerhaft fehlerhafte Einträge nach einer festgelegten Anzahl von Versuchen in eine sichtbare Fehlerbehandlung. Reihenfolge wird nur je Bestellung verlangt; zwischen verschiedenen Bestellungen besteht keine globale Reihenfolgegarantie.

## Übersetzung im Fulfillment-Kontext

Fulfillment besitzt ein eigenes Modell. Der Eingangsadapter validiert den Vertrag und übersetzt ihn in den lokalen Befehl `LieferauftragAusBestaetigterBestellungAnlegen`.

```java
public void verarbeiten(OrderConfirmedV1 nachricht) {
    transaktionen.ausfuehren(() -> {
        if (eingangsbuch.istVerarbeitet(nachricht.eventId())) return;

        ExterneBestellungId bestellungId = new ExterneBestellungId(nachricht.orderId());
        if (lieferauftraege.existiertFuer(bestellungId)) {
            klaerungen.melden(new BestellungMehrfachBestaetigt(bestellungId, nachricht.eventId()));
            eingangsbuch.alsVerarbeitetMarkieren(nachricht.eventId());
            return;
        }

        Lieferauftrag lieferauftrag = Lieferauftrag.ausBestaetigterBestellung(
                bestellungId,
                adressMapper.abbilden(nachricht.deliveryAddress()),
                positionsMapper.abbilden(nachricht.lines()));

        lieferauftraege.anlegen(lieferauftrag);
        eingangsbuch.alsVerarbeitetMarkieren(nachricht.eventId());
    });
}
```

Das Anlegen des Lieferauftrags und das Markieren der `eventId` erfolgen atomar. Trifft eine abweichende `eventId` auf eine bereits belieferte Bestellung, entsteht statt eines zweiten Lieferauftrags ein sichtbarer Konfliktbefund; die externe Bestell-ID verhindert so, dass zwei verschiedene Ereignis-IDs zwei Lieferaufträge für dieselbe Bestellung erzeugen.

## Verantwortungsgrenze

- Vertrieb entscheidet, ob und mit welchem Inhalt eine Bestellung bestätigt ist.
- Fulfillment entscheidet, wie daraus ein Lieferauftrag und eine Zustellplanung entstehen.
- Fulfillment darf Vertriebsdaten nicht zurückschreiben.
- Eine fachliche Ablehnung im Fulfillment macht die bereits bestätigte Bestellung nicht ungeschehen; sie erzeugt einen sichtbaren Klärungsprozess.

## Maßgebliche Regeln

- [DDD-BC-001](../../../rules/05-bounded-contexts.md)
- [DDD-EVT-001](../../../rules/11-domain-events.md)
- [DDD-INF-001](../../../rules/13-infrastructure-layer.md)
- [DDD-INT-001](../../../rules/14-context-integration.md)
- [DDD-TEST-001](../../../rules/15-testing.md)
