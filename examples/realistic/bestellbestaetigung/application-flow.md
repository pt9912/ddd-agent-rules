# Anwendungsablauf und Transaktion

## Verantwortlichkeit des Anwendungsdienstes

Der Anwendungsdienst authentifiziert den Aufrufer, prüft dessen grobe Berechtigung für den Anwendungsfall und koordiniert Ports. Er entscheidet nicht selbst, ob die konkrete Bestellung bestätigt werden darf.

```java
public record BestellungBestaetigen(
        BestellungId bestellungId,
        BearbeiterId bearbeiterId,
        Optional<BestellfreigabeId> freigabeId) {}

public final class BestellungBestaetigenService {
    private final BestellungsRepository bestellungen;
    private final Bestellfreigaben bestellfreigaben;
    private final Transaktionen transaktionen;
    private final Outbox outbox;
    private final IntegrationsereignisMapper mapper;
    private final Bestellrichtlinie richtlinie;
    private final Uhr uhr;

    public void ausfuehren(BestellungBestaetigen befehl) {
        zugriffAufAnwendungsfallPruefen(befehl.bearbeiterId());

        transaktionen.ausfuehren(() -> {
            Bestellung bestellung = bestellungen.laden(befehl.bestellungId())
                    .orElseThrow(() -> new NichtGefunden("Bestellung"));
            Optional<Bestellfreigabe> freigabe = befehl.freigabeId()
                    .flatMap(bestellfreigaben::laden);

            bestellung.bestaetigen(richtlinie, freigabe, uhr.jetzt());
            List<Domaenenereignis> ereignisse = bestellung.ereignisseEntnehmen();

            bestellungen.speichern(bestellung);
            ereignisse.stream()
                    .map(mapper::abbilden)
                    .forEach(outbox::speichern);
        });
    }
}
```

Die zustandsabhängige Entscheidung verbleibt in `Bestellung.bestaetigen`. Dadurch kann weder ein anderer Handler noch ein Stapelimport die Freigaberegel umgehen.

## Ports

Die Anwendung kennt fachlich benannte Ports, aber keine ORM-Session und keinen Message Broker.

```java
public interface BestellungsRepository {
    Optional<Bestellung> laden(BestellungId id);
    void speichern(Bestellung bestellung);
}

public interface Bestellfreigaben {
    Optional<Bestellfreigabe> laden(BestellfreigabeId id);
}

public interface Transaktionen {
    void ausfuehren(Runnable arbeit);
}

public interface Outbox {
    void speichern(AusgehendeNachricht nachricht);
}
```

Der Anwendungsdienst übernimmt keine vom Aufrufer konstruierte Freigabe, sondern lädt den fachlichen Nachweis über seine ID aus einer vertrauenswürdigen Quelle. Das Aggregat prüft anschließend selbst, ob der Nachweis zu Bestellung und Betrag passt.

Der Persistenzadapter für `BestellungsRepository` und der Adapter für `Outbox` verwenden dieselbe Datenbanktransaktion. Schlägt das Speichern eines der beiden Artefakte fehl, werden beide Änderungen zurückgerollt.

## Commit-Grenze

Der Anwendungsdienst veröffentlicht keine Nachricht. Ein separater Outbox-Publisher arbeitet ausschließlich mit bereits bestätigten Transaktionen:

```text
Transaktion A:
  Bestellung laden
  Aggregatverhalten ausführen
  Bestellung speichern
  Outbox-Eintrag speichern
  COMMIT

Outbox-Publisher:
  unveröffentlichte Einträge lesen
  an Broker senden
  Eintrag als veröffentlicht markieren
```

Ein Absturz nach dem Senden und vor dem Markieren kann eine erneute Zustellung verursachen. Deshalb lautet die Garantie mindestens einmal, nicht genau einmal. Der Downstream muss Duplikate erkennen.

## Fehlersemantik

| Fehler | Ergebnis |
| --- | --- |
| Fachliche Ablehnung | Kein Commit, kein Outbox-Eintrag |
| Fehler beim Speichern der Bestellung | Rollback von Bestellung und Outbox |
| Fehler beim Speichern der Outbox | Rollback von Bestellung und Outbox |
| Broker nicht erreichbar | Bestellung bleibt bestätigt; Outbox-Publisher versucht es erneut |
| Absturz nach Brokerversand | Nachricht kann doppelt ankommen; Empfänger verarbeitet idempotent |

## Maßgebliche Regeln

- [DDD-REP-001](../../../rules/10-repositories.md)
- [DDD-APP-001](../../../rules/12-application-layer.md)
- [DDD-INF-001](../../../rules/13-infrastructure-layer.md)
- [DDD-TEST-001](../../../rules/15-testing.md)
