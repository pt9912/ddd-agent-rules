# Teststrategie und kritische Szenarien

## Schnelle Domänentests

Domänentests verwenden keine Datenbank, keinen Broker und kein Webframework. Sie prüfen beobachtbares Verhalten der Aggregatwurzel.

```java
@Test
void leereBestellungKannNichtBestaetigtWerden() {
    Bestellung bestellung = eineBestellungImEntwurf();
    bestellung.lieferadresseFestlegen(eineLieferadresse());

    assertThatThrownBy(() -> bestellung.bestaetigen(
            richtlinieMitGrenze("10000.00"), Optional.empty(), festerZeitpunkt()))
            .isInstanceOf(FachlicheAblehnung.class)
            .hasMessageContaining("Mindestens eine Position");

    assertThat(bestellung.status()).isEqualTo(Bestellstatus.ENTWURF);
    assertThat(bestellung.ereignisseEntnehmen()).isEmpty();
}

@Test
void bestellungOberhalbDerGrenzeBrauchtPassendeFreigabe() {
    Bestellung bestellung = bestellungUeber("12450.00");

    assertThatThrownBy(() -> bestellung.bestaetigen(
            richtlinieMitGrenze("10000.00"), Optional.empty(), festerZeitpunkt()))
            .isInstanceOf(FachlicheAblehnung.class)
            .hasMessageContaining("Bestellfreigabe");
}

@Test
void gueltigeBestellungWirdBestaetigtUndErzeugtEineTatsache() {
    Bestellung bestellung = bestellungUeber("12450.00");
    Bestellfreigabe freigabe = freigabeFuer(bestellung.id(), "13000.00");

    bestellung.bestaetigen(
            richtlinieMitGrenze("10000.00"), Optional.of(freigabe), festerZeitpunkt());

    assertThat(bestellung.status()).isEqualTo(Bestellstatus.BESTAETIGT);
    assertThat(bestellung.ereignisseEntnehmen())
            .singleElement()
            .isInstanceOf(BestellungBestaetigt.class);
}

@Test
void bestaetigteBestellungKannNichtMehrVeraendertWerden() {
    Bestellung bestellung = eineBestaetigteBestellung();

    assertThatThrownBy(() -> bestellung.positionHinzufuegen(einePosition()))
            .isInstanceOf(FachlicheAblehnung.class)
            .hasMessageContaining("nicht mehr veränderbar");
}
```

Weitere Domänentests decken eine fehlende Lieferadresse, nicht positive Gesamtbeträge, eine Freigabe für die falsche Bestellung, eine zu niedrige Freigabe und gemischte Währungen ab.

Ein Anwendungstest weist zusätzlich nach, dass eine unbekannte oder vom Aufrufer nur behauptete Freigabe nicht als fachlicher Nachweis akzeptiert wird.

## Integrationstests der Transaktionsgrenze

Diese Tests verwenden den echten Persistenz- und Outbox-Adapter gegen eine kontrollierte Testdatenbank.

| Szenario | Nachweis |
| --- | --- |
| Erfolgreiche Bestätigung | Bestellstatus und genau ein Outbox-Eintrag werden gemeinsam gespeichert. |
| Fehler beim Speichern der Outbox | Der Bestellstatus bleibt nach dem Rollback `ENTWURF`. |
| Fehler beim Speichern der Bestellung | Es bleibt kein Outbox-Eintrag zurück. |
| Broker während der Transaktion nicht verfügbar | Die Transaktion benötigt keinen Broker und kann erfolgreich committen. |
| Publisher nach Commit | Nur committed Outbox-Einträge werden veröffentlicht. |

Ein Test, der lediglich Repository und Outbox mockt, kann die Atomizität nicht nachweisen. Dafür ist ein fokussierter Integrationstest erforderlich.

## Vertrags- und Nachrichtentests

- Ein Golden-File-Test schützt Feldnamen, Datentypen und Version von `sales.order-confirmed.v1`.
- Ein Mapper-Test weist nach, dass keine internen Freigabe- oder Domänentypen in den Vertrag gelangen.
- Ein Consumer-Test stellt dieselbe `eventId` zweimal zu und erwartet genau einen Lieferauftrag.
- Ein Consumer-Test stellt zwei verschiedene `eventId`-Werte für dieselbe `orderId` zu und erwartet weiterhin genau einen Lieferauftrag sowie einen sichtbaren Konfliktbefund.
- Ein Fehlertest weist nach, dass das Eingangsereignis bei einem Rollback nicht als verarbeitet markiert wird.
- Ein Wiederholungstest weist nach, dass eine vorübergehende Brokerstörung den Outbox-Eintrag nicht verliert.

## Abnahmekriterium

Die Fallstudie gilt nur dann als korrekt umgesetzt, wenn Domänentests die Invarianten ohne Infrastruktur prüfen und Integrationstests die Commit-, Rollback- und Idempotenzsemantik an den tatsächlichen Adaptern nachweisen.

## Maßgebliche Regeln

- [DDD-AGG-001](../../../rules/08-aggregates.md)
- [DDD-EVT-001](../../../rules/11-domain-events.md)
- [DDD-APP-001](../../../rules/12-application-layer.md)
- [DDD-INT-001](../../../rules/14-context-integration.md)
- [DDD-TEST-001](../../../rules/15-testing.md)
