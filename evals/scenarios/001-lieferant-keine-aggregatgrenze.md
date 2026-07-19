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

## Referenzlösung (Prüfmaßstab)

Eine korrekte Antwort erfüllt:

- **[nein]** `Lagerartikel` erhält Felder für Lieferantenname/-E-Mail.
- **[ja]** Der Lieferant bleibt über `LieferantId` referenziert.
- **[ja]** Die Kontaktdaten werden außerhalb des Aggregats beschafft (Lesemodell / Anwendungsschicht / ACL zum Kontext Einkauf).
- **[ja]** Der DB-Fremdschlüssel gilt als Infrastrukturdetail, nicht als Aggregatgrenze.

## Akzeptanzkriterien

Die Kernfrage — wird das fremde Aggregat in `Lagerartikel` eingebettet? — ist
semantisch und wird vom LLM-Judge entschieden. Eine reine Substring-Prüfung kann
„fügt Feld hinzu" nicht von „nennt das Feld, um es abzulehnen" unterscheiden
(ein Lesemodell-DTO außerhalb des Aggregats darf `lieferantName` heißen). Der
folgende ```grading-Vorfilter prüft daher nur robuste Signale: mindestens eine
einschlägige Grenz-Regel-ID, die beibehaltene `LieferantId`-Referenz und eine
deklarierte (beliebige) Bereitschaftsstufe. `analysis-only` ist hier ebenso
zulässig wie `ready`/`conditional`, weil der Auftrag in wörtlicher Form eine
Grenzverletzung nahelegt.

```grading
bereitschaft: ready conditional analysis-only
pflicht-any: DDD-AGG-001 DDD-BC-001 DDD-INT-001
pflicht: LieferantId
```
