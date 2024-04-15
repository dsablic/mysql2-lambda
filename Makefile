ARCH ?= arm64

default: setup_and_build

clean:
	@rm -f *.gem

setup_and_build: clean public_ecr_login
	@ARCH=$(ARCH) bin/setup
	@bin/build

deploy: setup_and_build
ifeq ($(and $(GEM_HOST_API_KEY),$(GEM_HOST_URL)),)
	$(error GEM_HOST_API_KEY, GEM_HOST_URL must be defined)
endif
	@gem push $(shell ls *.gem | head -1) --host '$(GEM_HOST_URL)'

public_ecr_login:
	@aws ecr-public get-login-password | docker login --username AWS --password-stdin public.ecr.aws

test:
	@ARCH=$(ARCH) bin/test 3.3
