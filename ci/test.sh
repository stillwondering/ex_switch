#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Runs all tests including coverage report.
main () {
  mix test --color --cover
}

main "$@"
