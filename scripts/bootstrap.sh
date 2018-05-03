#!/bin/sh

carthage bootstrap --no-use-binaries --no-build --use-ssh
cp Cartfile.resolved Carthage
