.DEFAULT_GOAL := lint


THIS_FILE := $(lastword $(MAKEFILE_LIST))
WORKSPACE_LOCATION := PokemonViewer.xcworkspace
SCHEME_NAME := PokemonViewer
DERIVED_DATA := ${HOME}/Library/Developer/Xcode/DerivedData

lint:

ifeq (, $(shell command -v  swiftlint))
	echo "warning: No swiftlint in $(PATH), consider doing make setup"
else
	swiftlint --strict --config .swiftlint.yml
endif

clean:
	xcodebuild -workspace '$(WORKSPACE_LOCATION)' -scheme '$(SCHEME_NAME)' clean
	rm -rf "$(DERIVED_DATA)"
	rm -rf .swiftpm/xcode/*

test:
	set -o pipefail && xcodebuild \
		-workspace $(WORKSPACE_LOCATION) \
		-scheme '$(SCHEME_NAME)' \
		-derivedDataPath "$(DERIVED_DATA)" \
		-destination 'platform=iOS Simulator,name=iPhone SE (2nd generation),OS=latest' \
		test | tee 'xcodebuild.log'

setup:
	brew update && brew bundle

brew:
	 /bin/bash -c "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh`"
