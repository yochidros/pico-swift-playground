TOOLCHAINS="org.swift.59202408071a"
BOARD="pico"
PICO_TOOLCHAIN_PATH="/Applications/LLVM-ET-Arm-18.1.3-Darwin-universal"
CWD := $(shell pwd)

.PHONY: build setup

build:
	set -e; \
	TOOLCHAINS=$(TOOLCHAINS) PICO_SDK_PATH="$(CWD)/../pico-sdk" PICO_BOARD=$(BOARD) cmake --build build
	@echo "🚀 Done 🚀"


setup:
	rm -rf build
	TOOLCHAINS=$(TOOLCHAINS) PICO_SDK_PATH="$(CWD)/../pico-sdk" PICO_BOARD=$(BOARD) cmake -B build -G 'Ninja'

clean:
	rm -rf build

install:
	cp ./build/pico_swift.uf2 /Volumes/RPI-RP2/

llvm:
	set -e; \
	TOOLCHAINS=$(TOOLCHAINS) PICO_SDK_PATH="$(CWD)/../pico-sdk-2" PICO_DEFAULT_COMPILER="pico_arm_clang"  PICO_COMPILER="pico_arm_clang" PICO_TOOLCHAIN_PATH=$(PICO_TOOLCHAIN_PATH) PICO_BOARD=$(BOARD) cmake --build build
	@echo "🚀 Done by LLVM 🚀"

setup_llvm:
	rm -rf build
	TOOLCHAINS=$(TOOLCHAINS) PICO_SDK_PATH="$(CWD)/../pico-sdk-2" PICO_DEFAULT_COMPILER="pico_arm_clang"  PICO_COMPILER="pico_arm_clang" PICO_TOOLCHAIN_PATH=$(PICO_TOOLCHAIN_PATH) PICO_BOARD=$(BOARD) cmake -B build -G 'Ninja'

