#!/usr/bin/env bash

quote="$(nix run nixpkgs#fortune -- -n 90 -s | head -n 1)"
echo "$quote"
