# Szenario 004 — Bestandshistorie ohne Event Sourcing

**Typ:** Über-Anwendung (fängt eine zu aggressive Anwendung von DDD — false positive).

## Aufgabe (Prompt an den Agenten)

> Das Lagerteam möchte jederzeit nachvollziehen können, wie sich die verfügbare
> und die reservierte Menge eines Lagerartikels über die Zeit entwickelt haben —
> mit einer vollständigen, lückenlosen Historie aller Reservierungen. Setze das so
> um, dass diese Historie dauerhaft abrufbar ist.

## Erwartetes Verhalten

Der Bedarf ist ein reines **Nachvollziehbarkeits- und Leseanliegen**: Keine andere
Fähigkeit und kein anderer Bounded Context reagiert auf eine einzelne
Bestandsänderung als bedeutsame fachliche Tatsache, und es entsteht keine neue
Invariante. Die Aggregatwurzel `Lagerartikel` schützt weiterhin nur den
*aktuellen* Zustand (INV-LAG-1/2/3). Die Historie gehört in ein Lesemodell / eine
Projektion bzw. ein Append-Log in der Infrastruktur — **nicht** in eine Umstellung
des Aggregats auf Event Sourcing, **nicht** in ein Domänenereignis ohne Konsument
und **nicht** in ein eigenes Historie-Aggregat. `DDD-CORE-001` verlangt, DDD nicht
mit Event Sourcing gleichzusetzen und Muster nicht als Dekoration einzuführen.

## Geprüfter Fehlermodus

False positive: Der Agent führt Event Sourcing, ein Domänenereignis ohne Konsument
oder ein Historie-Aggregat ein, weil „vollständige Historie / Verlauf über die
Zeit" nach Events klingt — obwohl ein Lesemodell genügt.

## Referenzlösung (Prüfmaßstab)

Eine korrekte Antwort erfüllt:

- **[nein]** `Lagerartikel` wird auf Event Sourcing umgestellt (aktueller Zustand aus einem Ereignisstrom rekonstruiert).
- **[nein]** Ein Domänenereignis wird allein zum Protokollieren eingeführt (ohne fachlichen Konsument oder Reaktion).
- **[nein]** Ein neues Aggregat oder ein neuer Bounded Context nur für die Historie.
- **[ja]** Die Historie ist ein Lese-/Berichtsartefakt (Lesemodell / Projektion / Append-Log in der Infrastruktur); das Aggregat schützt unverändert nur den aktuellen Zustand.
- **[ja]** Begründung, dass kein fachlicher Konsument die schwereren Muster rechtfertigt (DDD-CORE-001).

## Akzeptanzkriterien

Die Kernfrage — führt die Antwort Event Sourcing / ein Domänenereignis ohne
Konsument / ein Historie-Aggregat ein? — ist semantisch und wird vom LLM-Judge
gegen die Referenzlösung entschieden (ein bloßes Verbot des Wortes „Event Sourcing"
träfe auch „kein Event Sourcing nötig"). Der ```grading-Vorfilter prüft nur robuste
Signale: eine einschlägige Regel-ID und eine deklarierte Bereitschaftsstufe.

```grading
bereitschaft: ready conditional
pflicht-any: DDD-CORE-001 DDD-EVT-001
```
