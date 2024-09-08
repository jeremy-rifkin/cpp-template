default: help

# The general philosophy and functionality of this makefile is shamelessly stolen from compiler explorer

help: # with thanks to Ben Rady
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

PYTHON ?= python3
CMAKE ?= cmake
MAKE ?= make
PROFILE ?= default
BUILD_TYPE ?= debug
BUILD_TYPE_UPPER ?= $(shell bash -c 'BUILD_TYPE=$(BUILD_TYPE); echo $${BUILD_TYPE^}')

ifndef VERBOSE
MAKEFLAGS += --no-print-directory
endif

.venv/touchfile:
	$(PYTHON) -m venv .venv
	touch .venv/touchfile

build/conan/build/$(BUILD_TYPE_UPPER)/generators/conan_toolchain.cmake: .venv/touchfile conanfile.py
	mkdir -p build
	. .venv/bin/activate; pip install conan; conan profile detect --name $(PROFILE) --exist-ok
	. .venv/bin/activate; conan graph info conanfile.py --format=html --profile:all=$(PROFILE) > build/conangraph.html
	. .venv/bin/activate; conan install . --build=missing -s build_type=$(BUILD_TYPE_UPPER) -of build/conan --profile:all=$(PROFILE) --lockfile-partial --lockfile-out=conan.lock

build/configured-$(BUILD_TYPE): build/conan/build/$(BUILD_TYPE_UPPER)/generators/conan_toolchain.cmake
	$(CMAKE) -S . -B build/$(BUILD_TYPE) -GNinja -DCMAKE_BUILD_TYPE=$(BUILD_TYPE_UPPER) -DCMAKE_EXPORT_COMPILE_COMMANDS=On -DCMAKE_TOOLCHAIN_FILE=build/conan/build/$(BUILD_TYPE_UPPER)/generators/conan_toolchain.cmake -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
	rm -f build/configured-*
	touch build/configured-$(BUILD_TYPE)

.PHONY: build
build: build/configured-$(BUILD_TYPE)  ## build in debug mode
	$(CMAKE) --build build/$(BUILD_TYPE)

.PHONY: debug
debug:  ## build in debug mode
	BUILD_TYPE=debug $(MAKE) build

.PHONY: release
release:  ## build in release mode
	BUILD_TYPE=release $(MAKE) build

.PHONY: test
test: $(BUILD_TYPE)  ## test
	$(CMAKE) --build build/$(BUILD_TYPE) --target all_tests
	cd build/$(BUILD_TYPE) && ninja test

.PHONY: test-release
test-release:  ## test-release
	BUILD_TYPE=release $(MAKE) test

.PHONY: benchmark-hidden
benchmark-hidden: $(BUILD_TYPE)
	$(CMAKE) --build build/$(BUILD_TYPE) --target all_benchmarks

.PHONY: benchmark
benchmark:  ## benchmark-release
	BUILD_TYPE=release $(MAKE) benchmark-hidden

.PHONY: benchmark-release
benchmark-release: benchmark  ## benchmark-release


.PHONY: clean
clean:  ## clean the build folder
	rm -rf build

.PHONY: clean-all
clean-all: clean  ## clean everything created by make
	rm -rf .venv
