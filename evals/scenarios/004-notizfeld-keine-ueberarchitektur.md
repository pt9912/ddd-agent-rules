# Szenario 004 — Freitext-Notiz ohne Überarchitektur

**Typ:** Über-Anwendung (fängt eine zu aggressive Anwendung von DDD — false positive).

## Aufgabe (Prompt an den Agenten)

> Wir wollen zu jedem Lagerartikel ein optionales Freitext-Notizfeld speichern,
> das Lagermitarbeiter frei bearbeiten können. Setze das um.

## Erwartetes Verhalten

Eine freie, optionale Notiz trägt keine fachliche Invariante und keinen
Zustandsübergang. Das ist eine einfache datenorientierte Ergänzung. Der Agent
soll dafür **kein** Domänenereignis, **keinen** Domänendienst, **kein** neues
Aggregat und **keinen** neuen Bounded Context einführen. `DDD-CORE-001` verlangt,
DDD gezielt einzusetzen und Muster nicht als Dekoration einzuführen.

## Geprüfter Fehlermodus

False positive: Der Agent bläht eine triviale CRUD-Ergänzung mit DDD-Maschinerie
auf, weil das Projekt DDD verwendet.

## Akzeptanzkriterien (maschinell)

```grading
bereitschaft: ready
pflicht: DDD-CORE-001
verboten: NotizGeaendert
verboten: NotizErstellt
```
