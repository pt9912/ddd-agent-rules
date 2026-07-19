---
id: DDD-READY-001
title: Fachliche Änderungsbereitschaft vor der Umsetzung herstellen
category: agent-readiness
priority: mandatory
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Fachliche Änderungsbereitschaft vor der Umsetzung herstellen

## Absicht

Verhindere, dass ein Code-Agent fachliche Grenzen, Begriffe oder Regeln aus technischen Strukturen erfindet und eine unsichere Änderung als belastbare DDD-Umsetzung darstellt.

## Regel

Vor einer nicht trivialen fachlichen Änderung MUSS der Agent Änderungsziel, geschütztes Verhalten, betroffenen Bounded Context, maßgebliche Domänensprache, betroffenes Domänenkonzept mit relevanten Invarianten sowie eine ausführbare Verifikation ausreichend bestimmen.

## Verbindliches Verhalten

- MUSS zuerst vorhandenen Code, Tests, Domänendokumentation und etablierte Terminologie untersuchen.
- MUSS ausdrückliche fachliche Entscheidungen und aktuelles Benutzerziel von bloßen technischen Indizien unterscheiden.
- MUSS Konflikte zwischen Dokumentation, Tests und beobachtetem Verhalten sichtbar machen.
- MUSS bestimmen, welches Verhalten bewahrt werden muss und welches ausdrücklich geändert werden darf.
- MUSS Bounded Context, betroffenes Aggregat oder Domänenkonzept und relevante Invarianten benennen.
- MUSS verfügbare Build-, Test- und Validierungsbefehle bestimmen.
- MUSS fehlende fachliche Informationen als offene Frage oder ausdrückliche Annahme kennzeichnen.
- MUSS die Arbeit auf Analyse und Klärung begrenzen, wenn eine offene Frage Aggregatgrenze, Invariante, Domänenbedeutung oder öffentliches Verhalten wesentlich verändern kann.
- MUSS bei Implementierung oder Refaktorierung die betroffenen Invarianten durch Tests nachweisen.

## Verbotenes Verhalten

- DARF NICHT Aggregat- oder Kontextgrenzen allein aus Tabellen, Fremdschlüsseln, Paketstruktur oder API-Formen ableiten.
- DARF NICHT fehlende fachliche Regeln durch vermeintlich übliche DDD-Muster ersetzen.
- DARF NICHT widersprüchliche Evidenz stillschweigend zugunsten der bequemsten Implementierung auflösen.
- DARF NICHT eine nur angenommene Invariante als bestätigte Fachregel darstellen.
- DARF NICHT eine fachliche Änderung als sicher abgeschlossen melden, wenn ihre kritische Verifikation nicht ausführbar war.

## Entscheidungskriterien

### Evidenzreihenfolge

Bewerte Quellen im konkreten Kontext. Als Ausgangspunkt gilt:

1. ausdrückliches aktuelles Änderungsziel und bestätigte fachliche Entscheidung
2. freigegebene Domänendokumentation, Glossar und Architekturentscheidungen
3. ausführbare Tests des bestehenden öffentlichen Verhaltens
4. beobachtbares Verhalten des bestehenden Codes
5. Datenbank-, Transport- und Frameworkstrukturen als technische Indizien

Ein höher eingeordneter Beleg hebt einen Widerspruch nicht automatisch auf. Der Agent muss den Konflikt dokumentieren und bei wesentlicher fachlicher Auswirkung klären lassen.

### Bereitschaftsstufen

| Stufe | Bedeutung | Zulässige Arbeit |
| --- | --- | --- |
| `ready` | Fachlicher Umfang und Verifikation sind ausreichend bestimmt. | Implementieren, refaktorieren oder prüfen. |
| `conditional` | Begrenzte Annahmen ändern weder Kontextgrenze noch Invariante oder öffentliches Verhalten. | Mit ausdrücklich genannten Annahmen und passenden Tests fortfahren. |
| `analysis-only` | Eine offene Frage kann Modellgrenze, Invariante oder Verhalten wesentlich verändern. | Untersuchen, Optionen erklären und Klärung einholen; keine fachliche Umsetzung als endgültig darstellen. |

Technische Wartung ohne Einfluss auf fachliches Verhalten benötigt keine neue Domänenmodellierung. Der Agent muss dennoch nachweisen, warum die Änderung fachlich neutral ist.

## Prüfung

- Sind Änderungsziel und zu bewahrendes Verhalten ausdrücklich?
- Sind Bounded Context, Domänenbegriffe und betroffenes Konzept ausreichend bekannt?
- Welche Invarianten werden berührt und wodurch sind sie belegt?
- Widersprechen sich Dokumentation, Tests und Code?
- Können relevante Tests und Validierungen ausgeführt werden?
- Ist die Bereitschaft als `ready`, `conditional` oder `analysis-only` begründet?
- Sind Annahmen und ungeklärte Domänenfragen sichtbar?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-DOMAIN-ANALYSIS](../sources/references.md#ms-domain-analysis)
