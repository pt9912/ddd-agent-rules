# Eval-Harness für die Wirksamkeit des DDD-Regelwerks.
#
# Bewusst getrennt vom Wurzel-Makefile: Dieses steuert das Aufsetzen, Ausführen,
# Bewerten und Verifizieren von Ziel-Repos, während das Wurzel-Makefile nur
# dieses Regelwerk-Repo validiert (test/validate/doc-check).
#
# Aufruf aus der Repo-Wurzel, z. B.:
#   make -C evals init   DIR=/pfad/ziel
#   make -C evals verify DIR=/pfad/ziel SCENARIO=003

EVAL_IMAGE = ddd-eval-verify

.PHONY: init run grade image verify

# 1. Fixture-Ziel-Repo aufsetzen: make -C evals init DIR=/pfad/ziel [ARGS=--with-hilfen]
init:
	@test -n "$(DIR)" || { echo "Aufruf: make -C evals init DIR=/pfad/ziel [ARGS=--with-hilfen]"; exit 2; }
	./init-fixture.sh "$(DIR)" $(ARGS)

# 2. Agenten-Prompt zusammensetzen (stdout):
#    make -C evals run SCENARIO=scenarios/001-*.md DIR=/ziel OUT=/ziel/out/A-1.md [ARM=ohne]
run:
	@test -n "$(SCENARIO)" && test -n "$(DIR)" && test -n "$(OUT)" || { echo "Aufruf: make -C evals run SCENARIO=<szenario.md> DIR=<ziel> OUT=<ausgabe> [ARM=ohne]"; exit 2; }
	./run-scenario.sh $(SCENARIO) "$(DIR)" "$(OUT)" $(if $(filter ohne,$(ARM)),--ohne-regelwerk,)

# 3a. Signal-Assert-Grading (kein Docker nötig):
#     make -C evals grade SCENARIO=scenarios/001-*.md OUT="/ziel/out/A-1.md /ziel/out/A-2.md"
grade:
	@test -n "$(SCENARIO)" && test -n "$(OUT)" || { echo "Aufruf: make -C evals grade SCENARIO=<szenario.md> OUT=<antwort...>"; exit 2; }
	./grade.sh $(SCENARIO) $(OUT)

# 3b. Ausführbare Verifikation (Ebene 1) im Container. Einmalig das JDK-Image bauen:
image:
	docker build -t $(EVAL_IMAGE) .

# ... dann je (vom Agenten bearbeitetem) Ziel-Repo verifizieren (read-only, kein Netz):
#     make -C evals verify DIR=/ziel SCENARIO=003
verify:
	@test -n "$(DIR)" && test -n "$(SCENARIO)" || { echo "Aufruf: make -C evals verify DIR=<ziel> SCENARIO=003"; exit 2; }
	docker run --rm --network none -v "$(abspath $(DIR)):/repo:ro" $(EVAL_IMAGE) $(SCENARIO)
