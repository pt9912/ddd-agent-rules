# Aggregat oder Entität?

1. Hat das Konzept eine Domänenidentität?
   - Nein: Ziehe ein Wertobjekt in Betracht.
   - Ja: Fahre fort.
2. Schützt es gemeinsam mit anderen Objekten eine Invariante?
   - Nein: Es kann eine Entität innerhalb eines bestehenden Aggregats sein.
   - Ja: Fahre fort.
3. Müssen sich diese Objekte atomar ändern?
   - Ja: Definiere eine Aggregatgrenze.
   - Nein: Verwende getrennte Aggregate und koordiniere sie durch Ereignisse oder Anwendungslogik.
4. Welches Objekt steuert Lebenszyklus und Änderungen?
   - Dieses Objekt ist der Kandidat für die Aggregatwurzel.

Leite die Antwort nicht allein aus Fremdschlüsseln oder Objektnavigation ab.

## Maßgebliche Regeln

- [DDD-ENT-001](../rules/06-entities.md)
- [DDD-VO-001](../rules/07-value-objects.md)
- [DDD-AGG-001](../rules/08-aggregates.md)
