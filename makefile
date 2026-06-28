.PHONY: build docs serve open diagram clean

PORT ?= 8000
SERVE = caddy file-server --root _docs/html-multi --listen :$(PORT)

build:
	lake build

docs:
	lake exe docs --output _docs

serve: docs
	$(SERVE)

open: docs
	@(until curl -sf -o /dev/null http://localhost:$(PORT)/; do sleep 0.1; done; \
	  xdg-open http://localhost:$(PORT)/) &
	$(SERVE)

diagram:
	$(MAKE) -C diagram

clean:
	lake clean
	rm -rf _docs
	$(MAKE) -C diagram clean
