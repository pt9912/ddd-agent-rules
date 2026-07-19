# In das Ziel-Repo kopieren (als ddd-verify/). Aus der Repo-Wurzel aufrufen:
#   make -C ddd-verify verify
#
# Erwartet die Invariantentests unter ddd-invariants/ in der Repo-Wurzel.
IMAGE = ddd-verify

.PHONY: image verify

image:
	docker build -t $(IMAGE) .

verify: image
	docker run --rm --network none -v "$(abspath ..):/repo:ro" $(IMAGE)
