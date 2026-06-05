#!/bin/bash

# Test that a specific version of zmx installs correctly.

set -e

source dev-container-features-test-lib

check "zmx is installed" bash -c "command -v zmx"
check "zmx version is 0.6.0" bash -c "zmx version | grep -q '0.6.0'"

reportResults
