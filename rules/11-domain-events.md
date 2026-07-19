---
id: DDD-EVT-001
title: Tatsachen als Domänenereignisse veröffentlichen
category: domain-event
priority: recommended
status: active
applies_to:
  - implementation
  - refactoring
  - code-review
---

# Tatsachen als Domänenereignisse veröffentlichen

## Absicht

Mache wichtige fachliche Ergebnisse ausdrücklich und entkopple Reaktionen innerhalb eines Bounded Contexts.

## Regel

Ein Domänenereignis SOLLTE eine bedeutsame, bereits eingetretene Tatsache darstellen.

## Empfohlenes Verhalten

- SOLLTE Ereignisse in der Vergangenheitsform benennen.
- SOLLTE stabile Domänenidentifikatoren und relevante Tatsachen enthalten.
- SOLLTE ein Ereignis erst erfassen, nachdem das Aggregat den Zustandsübergang abgeschlossen und seine Invarianten bewahrt hat.
- SOLLTE festlegen, ob lokale Handler vor oder nach dem Commit der auslösenden Transaktion ausgeführt werden.
- SOLLTE Domänenereignisse an Kontextgrenzen in Integrationsereignisse übersetzen.
- SOLLTE eine ausgehende Integrationsnachricht atomar mit dem fachlichen Zustand persistieren, wenn zuverlässige kontextübergreifende Zustellung erforderlich ist; die verbindliche Transaktionsführung dafür liegt in der Anwendungsschicht.

## Abgeratenes Verhalten

- SOLLTE NICHT Ereignisse wie Befehle benennen.
- SOLLTE NICHT Domänenereignisse als Ersatz für unmittelbares Aggregatverhalten verwenden.
- SOLLTE NICHT interne Domänentypen über Grenzen von Bounded Contexts hinweg veröffentlichen.
- SOLLTE NICHT ein Integrationsereignis vor dem Commit der auslösenden Transaktion veröffentlichen.
- SOLLTE NICHT unmittelbar aus einem Aggregat veröffentlichen.
- SOLLTE NICHT ohne Infrastrukturgarantien eine Genau-einmal-Zustellung annehmen.
- SOLLTE NICHT ein Domänenereignis allein zur Protokollierung oder Nachvollziehbarkeit einführen, ohne dass ein fachlicher Konsument oder eine Reaktion es rechtfertigt.

## Entscheidungskriterien

Verwende ein Ereignis, wenn eine fachliche Tatsache in der ubiquitären Sprache bedeutsam ist und eine entkoppelte fachliche Reaktion oder Koordination sie rechtfertigt. Mehrere Reaktionen sind nicht erforderlich, aber reine Nachvollziehbarkeit oder Protokollierung rechtfertigt für sich genommen kein Domänenereignis — dafür genügen ein Lesemodell oder ein Infrastruktur-Log.

## Prüfung

- Ist dies eine Tatsache in der Vergangenheitsform?
- Ist sie für Fachexperten bedeutsam?
- Ist sie intern oder kontextübergreifend?
- Kann ein externer Empfänger eine Änderung beobachten, die später zurückgerollt wird?
- Kann eine bestätigte Änderung ihre ausgehende Integrationsnachricht verlieren?
- Sind Handler dort idempotent, wo es erforderlich ist?
- Rechtfertigt ein fachlicher Konsument oder eine Reaktion dieses Ereignis, oder wäre es reine Nachvollziehbarkeit?

## Quellen

- [EVANS-DDD-REFERENCE](../sources/references.md#evans-ddd-reference)
- [MS-DOMAIN-EVENTS](../sources/references.md#ms-domain-events)
