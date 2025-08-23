#!/usr/bin/env bash

set -euo pipefail

greet() {
  local name="$1"
  echo "Hello, $name"
}

for person in Alice Bob Charlie; do
  greet "$person"
done