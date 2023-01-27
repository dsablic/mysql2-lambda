ARCH ?= arm64

default: setup_and_build

clean:
	@rm *.gem

setup_and_build: clean
	@ARCH=$(ARCH) bin/setup
	@bin/build

deploy: setup_and_build
ifeq ($(and $(GEM_HOST_API_KEY),$(GEM_HOST_URL)),)
	$(error GEM_HOST_API_KEY, GEM_HOST_URL must be defined)
endif
	@gem push $(shell ls *.gem | head -1) --host '$(GEM_HOST_URL)'
