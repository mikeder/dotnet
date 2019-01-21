SHELL := /bin/sh -e

ifeq (hugo,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.DEFAULT_GOAL := build
.PHONY: hugo

build:
	hugo

serve:
	hugo server --bind=0.0.0.0 -D -w

deps:
	docker build -t developer:latest .

dev:
	docker run --rm -it -v $$(pwd):/data -p1313:1313 developer:latest serve

publish:
ifeq "$(CODEBUILD_WEBHOOK_TRIGGER)" "branch/master"
	s3deploy -source=public -bucket=${AWS_BUCKET} -region=us-east-1
else
	@echo "Not on master branch, not publishing."
endif

hugo:
	docker run --rm -it -v $$(pwd):/data --entrypoint=/bin/hugo developer:latest ${RUN_ARGS}
