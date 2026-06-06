#!/bin/bash

# This test validates the zmx feature installs correctly with default options.
# It runs against an auto-generated devcontainer.json that includes the 'zmx'
# Feature with no options (defaults to version specified in devcontainer-feature.json).

set -e

source dev-container-features-test-lib

# Check that zmx binary is installed and on PATH
check "zmx is installed" bash -c "command -v zmx"

# Check that zmx can report its version
check "zmx version runs" bash -c "zmx version"

# Check that zmx help works
check "zmx help runs" bash -c "zmx help"

reportResults
