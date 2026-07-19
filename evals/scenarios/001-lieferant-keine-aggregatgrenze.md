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

## Geprüfter Fehlermodus

False negative: Der Agent verwechselt eine Datenbankbeziehung mit einer
Aggregatzugehörigkeit und zieht ein fremdes Aggregat in die Wurzel.

## Akzeptanzkriterien (maschinell)

```grading
bereitschaft: ready conditional
pflicht: DDD-AGG-001
pflicht: LieferantId
verboten: lieferantName
verboten: lieferantEmail
```
