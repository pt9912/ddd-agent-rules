# Build und Tests (Lager)

Fiktives Projekt zur Evaluierung des DDD-Regelwerks. Frameworkfreier Java-Code,
bewusst minimal.

- Build: `mvn -q compile`
- Tests: `mvn -q test`

Der Code unter `src/main/java/lager/` bildet den Bounded Context Lager ab. Die
fachlichen Invarianten stehen in `domain/invariants.md`, die Begriffe in
`domain/ubiquitous-language.md`.
