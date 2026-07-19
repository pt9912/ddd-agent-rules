# Szenario 001 — Lieferantendaten anzeigen, ohne die Aggregatgrenze zu verletzen

**Typ:** Falle / Verstoßerkennung (fängt eine zu schwache Aggregatgrenze).

## Aufgabe (Prompt an den Agenten)

> Erweitere den Lager-Kontext so, dass bei einer Reservierung die Kontaktdaten
> des Lieferanten (Name und E-Mail) mit angezeigt werden. In der Datenbank hat
> die Tabelle `lagerartikel` einen Fremdschlüssel `lieferant_id` auf die Tabelle
> `lieferant`, die Name und E-Mail enthält.

## Erwartetes Verhalten

Der Fremdschlüssel ist eine Datenbankbeziehung, keine Aggregatzugehörigkeit. Der
Lieferant gehört zum fremden Bounded Context *Einkauf* und wird im Lager nur über
`LieferantId` referenziert. Die Kontaktdaten gehören nicht in das Aggregat
`Lagerartikel`; sie werden außerhalb beschafft (Lesemodell bzw. Anwendungsschicht)
und erst für die Anzeige zusammengeführt.

## Akzeptanzkriterien

### Erwartete Bereitschaftsstufe
`ready` oder `conditional` (umsetzbar; offene Frage höchstens zur Eigentümerschaft
der Lieferantendaten).

### Pflicht-Signale (müssen vorkommen)
- Nennt `DDD-AGG-001` (fremde Aggregate über ihre Identität referenzieren).
- Behält die Referenz als `LieferantId`, ohne die Lieferant-Entität in
  `Lagerartikel` einzubetten.
- Schlägt vor, die Kontaktdaten außerhalb des Aggregats zu beschaffen und zu
  komponieren (Anwendungsschicht/Lesemodell; `DDD-APP-001`, `DDD-BC-001` oder
  `DDD-INT-001`).

### Verbotene Signale (dürfen NICHT vorkommen)
- Fügt `Lagerartikel` Felder wie `lieferantName` oder `lieferantEmail` hinzu.
- Leitet die Aggregatgrenze aus dem Fremdschlüssel `lieferant_id` ab.
- Lädt oder verändert `Lieferant` über die Wurzel `Lagerartikel`.

### Geprüfter Fehlermodus
False negative: Der Agent verwechselt eine Datenbankbeziehung mit einer
Aggregatzugehörigkeit und zieht ein fremdes Aggregat in die Wurzel.
