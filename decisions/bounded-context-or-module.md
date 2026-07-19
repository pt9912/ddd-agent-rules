# Bounded Context oder Modul?

Verwende ein Modul, wenn:

- Sprache und Modell konsistent bleiben
- die Eigentümerschaft geteilt ist
- sich Daten und Verhalten gemeinsam entwickeln
- die Trennung hauptsächlich organisatorisch innerhalb eines Modells ist

Verwende einen Bounded Context, wenn:

- Begriffe unterschiedliche Bedeutungen haben
- Regeln miteinander in Konflikt stehen
- sich die Eigentümerschaft unterscheidet
- sich Lebenszyklus oder Veröffentlichungstakt unterscheiden
- an der Grenze eine Übersetzung erforderlich ist

Ein Bounded Context kann als Modul in einem modularen Monolithen implementiert werden.
Er bedeutet nicht automatisch eine Netzwerkgrenze.

## Maßgebliche Regeln

- [DDD-BC-001](../rules/05-bounded-contexts.md)
