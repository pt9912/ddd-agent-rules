# Projektlebenszyklus

## Zweck

Der Projektlebenszyklus beschreibt den Zustand des Repositorys und seiner Veröffentlichungen. Er regelt Planung, Entwicklung, Validierung, Veröffentlichung, Wartung und Archivierung des Projekts als Ganzes.

Er bestimmt nicht, ob eine einzelne DDD-Regel fachlich gültig ist. Dafür gilt ausschließlich die Regel [DDD-Regellebenszyklus](../rules/01-rule-lifecycle.md).

## Zustände

| Zustand | Bedeutung | Eintrittskriterium | Austrittskriterium |
| --- | --- | --- | --- |
| `planning` | Umfang, Ziel und Auswirkungen einer Änderung werden geklärt. | Ein Änderungsbedarf wurde angenommen. | Betroffener Bounded Context, Domänenkonzept, Invarianten und Prüfumfang sind bestimmt. |
| `development` | Dokumente, Regeln, Beispiele und Prüfungen werden bearbeitet. | Der Änderungsumfang ist ausreichend klar. | Die Änderung ist vollständig und im Abschnitt `Unveröffentlicht` des Änderungsprotokolls dokumentiert. |
| `validation` | Der veröffentlichbare Stand wird geprüft. | Die Umsetzung ist abgeschlossen. | `make test` ist erfolgreich und offene fachliche Fragen sind gelöst oder ausdrücklich dokumentiert. |
| `released` | Ein geprüfter Stand ist versioniert und veröffentlicht. | Version, Änderungsprotokoll und Release-Artefakte stimmen überein. | Wartungs- oder Weiterentwicklungsbedarf entsteht. |
| `maintenance` | Ein veröffentlichter Stand erhält Korrekturen oder kompatible Verbesserungen. | Ein veröffentlichter Stand wird aktiv unterstützt. | Eine neue Änderung wechselt in `planning` oder das Projekt wird archiviert. |
| `archived` | Das Projekt wird nicht mehr aktiv weiterentwickelt. | Eine ausdrückliche Archivierungsentscheidung mit Hinweis auf Ersatz oder Folgen liegt vor. | Eine Reaktivierung wird ausdrücklich beschlossen und dokumentiert. |

## Übergänge

```text
planning → development → validation → released → maintenance
    ↑             │           │                       │
    └─────────────┴───────────┴───────────────────────┘
                                                   ↓
                                                archived
```

Ein fehlgeschlagenes Gate führt in den Zustand zurück, in dem die Ursache behoben werden kann. Ein Zustand darf nicht allein aufgrund eines Datums oder eines Git-Tags angenommen werden.

## Veröffentlichungsinvarianten

- Ein Release DARF NICHT veröffentlicht werden, wenn `make test` fehlschlägt.
- Eine inkompatible Änderung an stabilen Schnittstellen MUSS ausdrücklich versioniert und im Änderungsprotokoll erklärt werden.
- Ein Release MUSS alle enthaltenen Änderungen aus `Unveröffentlicht` nachvollziehbar übernehmen.
- Die Archivierung MUSS sichtbar dokumentieren, ob es einen Nachfolger gibt und welche Unterstützung endet.
- Ein Projektzustandswechsel DARF NICHT stillschweigend den Status einer DDD-Regel ändern.

## Aktueller Zustand

Das Projekt befindet sich in aktiver Weiterentwicklung. Der zuletzt dokumentierte Stand ist `0.1.0`; weitere Änderungen stehen unter `Unveröffentlicht`.

## Verantwortliche Artefakte

- `CHANGELOG.md` dokumentiert veröffentlichte und unveröffentlichte Änderungen.
- `README.md` beschreibt Nutzung, Validierung und stabile Schnittstellen.
- `Makefile`, `d-check.mk`, `scripts/` und `tests/` definieren die Freigabegates.
- Versions- und Release-Artefakte dokumentieren den Übergang zu `released`, sobald ein Release erstellt wird.
