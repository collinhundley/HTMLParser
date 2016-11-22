# Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Makefile

ifndef KITURA_CI_BUILD_SCRIPTS_DIR
KITURA_CI_BUILD_SCRIPTS_DIR = ./Build
endif

UNAME = ${shell uname}


ifeq ($(UNAME), Darwin)
SWIFTC_FLAGS = -Xswiftc -DNOJSON -Xswiftc -DMARIADB
LINKER_FLAGS = -Xlinker -L/usr/local/lib
endif

ifeq ($(UNAME), Linux)
SWIFTC_FLAGS = -Xswiftc -I/usr/include/mariadb -Xswiftc -I/usr/include/libxml2 -Xswiftc -DNOJSON -Xswiftc -DMARIADB
LINKER_FLAGS = -Xlinker -L/usr/lib/x86_64-linux-gnu
endif

all: build

build:
	@echo --- Invoking swift build
	swift build -c release $(SWIFTC_FLAGS) $(LINKER_FLAGS)

Tests/LinuxMain.swift:
ifeq ($(UNAME), Linux)
	@echo --- Generating $@
	bash ${KITURA_CI_BUILD_SCRIPTS_DIR}/generate_linux_main.sh
endif

test: build Tests/LinuxMain.swift
	@echo --- Invoking swift test
	swift test

refetch:
	@echo --- Removing Packages directory
	rm -rf Packages
	@echo --- Fetching dependencies
	swift package fetch

clean:
	@echo --- Invoking swift build --clean
	-swift build --clean
	rm -rf .build

xcode:
	swift package generate-xcodeproj
	./fix-xcode ${LIST=($(ls -td *.xcodeproj));basename ${LIST[0]} .xcodeproj}

.PHONY: clean build refetch run test xcode
