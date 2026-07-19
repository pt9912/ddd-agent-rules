# DDD-Invariantenverifikation (Vorlage)

Reproduzierbare, containerisierte Prüfung der Aggregatinvarianten dieses Repos —
unabhängig vom lokalen JDK. Eine Umsetzung von DDD-TEST-001 (fachliches Verhalten
und Invarianten testen).

## Übernahme

1. Kopiere diesen Ordner als `ddd-verify/` in die Wurzel deines Repos.
2. Lege Invariantentests unter `ddd-invariants/` in der Repo-Wurzel ab: je eine
   Java-Klasse mit `public static void main`, die die Invarianten einer
   Aggregatwurzel prüft und bei Verletzung mit Exit != 0 endet (oder eine
   Ausnahme wirft). Der Ordner `beispiel/` zeigt die Form.
3. Führe aus der Repo-Wurzel aus:

       make -C ddd-verify verify

Der Container kompiliert `src/main/java` zusammen mit `ddd-invariants/` und führt
jeden Test aus. Das Repo wird read-only gemountet, ohne Netzwerk. Die Basis ist
per Digest gepinnt.

## Anpassung

- Andere Quellpfade: `verify.sh` anpassen (Variable `src`).
- Maven/Gradle-Projekte können stattdessen ihren eigenen Test-Task im Container
  aufrufen; die Idee bleibt gleich: eine gepinnte, reproduzierbare Ausführung der
  Invariantentests.

Diese Vorlage ist eigenständig und referenziert das Regelwerk-Repo nicht, damit
sie unverändert in ein Ziel-Repo übernommen werden kann.
