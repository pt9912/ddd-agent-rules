DCHECK_DIGEST = sha256:9b80ce1d74e745cc266b476701bccb76059783916fe18651e00df96480a94364

include d-check.mk

.PHONY: test validate policy-contract d-check d-check-external

test: validate policy-contract doc-check

validate:
	./scripts/validate.sh

policy-contract:
	./tests/policy-contract.sh

d-check: doc-check

d-check-external:
	docker run --rm -v "$(CURDIR):/repo:ro" $(DCHECK_REF) --enable external
