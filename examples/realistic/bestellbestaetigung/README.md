# Fallstudie: Eine B2B-Bestellung bestätigen

## Zweck

Diese Fallstudie verbindet mehrere DDD-Regeln in einem realistischen Anwendungsfall. Die Java-Ausschnitte sind bewusst frameworkfrei und konzentrieren sich auf fachliche Entscheidungen, Transaktionsgrenzen und Integrationssemantik. Sie bilden keinen vollständigen Produktionsdienst ab.

## Fachliches Szenario

Ein Geschäftskunde stellt im Bounded Context **Vertrieb** eine Bestellung zusammen. Solange sie im Zustand `ENTWURF` ist, dürfen Positionen und Lieferadresse geändert werden. Durch die Bestätigung wird der vereinbarte Inhalt verbindlich.

Für die Bestätigung gelten folgende Invarianten:

- Die Bestellung befindet sich im Zustand `ENTWURF`.
- Sie enthält mindestens eine Position.
- Jede Position hat eine positive Menge und einen nicht negativen vereinbarten Einzelpreis.
- Eine vollständige Lieferadresse liegt vor.
- Der Gesamtbetrag ist größer als null.
- Überschreitet der Gesamtbetrag die Freigabegrenze, liegt eine zur Bestellung passende Freigabe über mindestens diesen Betrag vor.
- Nach der Bestätigung können Positionen und Lieferadresse nicht mehr verändert werden.

Akzeptiert die Aggregatwurzel den Übergang, entsteht das interne Domänenereignis `BestellungBestaetigt`. Vertrieb persistiert Bestellung und Outbox-Eintrag atomar. Erst nach dem Commit veröffentlicht ein Outbox-Publisher das Integrationsereignis `sales.order-confirmed.v1`.

## Kontextgrenze

| Rolle | Bounded Context | Eigenes Modell |
| --- | --- | --- |
| Upstream | Vertrieb | `Bestellung`, `Bestellposition`, `Bestellfreigabe` |
| Downstream | Fulfillment | `Lieferauftrag`, `Lieferposition`, Zustellplanung |

Fulfillment übernimmt weder das Aggregat `Bestellung` noch dessen Java-Typen. Es übersetzt den stabilen Integrationsvertrag in einen eigenen `Lieferauftrag` und verarbeitet wiederholt zugestellte Nachrichten idempotent.

## Ablauf

```text
Bestellung bestaetigen
        │
        ▼
Aggregat schützt Invarianten
        │
        ├── abgelehnt ──► keine Zustandsänderung, kein Ereignis
        │
        ▼
BestellungBestaetigt erfasst
        │
        ▼  eine Transaktion
Bestellung + Outbox-Eintrag persistiert
        │
        ▼  erst nach Commit
sales.order-confirmed.v1 veröffentlicht
        │
        ▼
Fulfillment legt Lieferauftrag idempotent an
```

## Bestandteile

1. [Domänenmodell und Invarianten](domain-model.md)
2. [Anwendungsablauf und Transaktion](application-flow.md)
3. [Kontextintegration und Zustellung](context-integration.md)
4. [Teststrategie und kritische Szenarien](tests.md)

## Bewusste Auslassungen

Stornierung, Zahlung, Lagerreservierung, Rabattermittlung und Teillieferung sind eigene fachliche Fähigkeiten. Sie werden nicht in das Bestellaggregat aufgenommen, nur um das Beispiel größer erscheinen zu lassen. Eine reale Modellierungsrunde müsste klären, ob dafür weitere Aggregate oder Bounded Contexts verantwortlich sind.

## Maßgebliche Regeln

- [DDD-CORE-001](../../../rules/00-core-principles.md)
- [DDD-MOD-001](../../../rules/03-domain-modeling.md)
- [DDD-BC-001](../../../rules/05-bounded-contexts.md)
- [DDD-AGG-001](../../../rules/08-aggregates.md)
- [DDD-EVT-001](../../../rules/11-domain-events.md)
- [DDD-INT-001](../../../rules/14-context-integration.md)
