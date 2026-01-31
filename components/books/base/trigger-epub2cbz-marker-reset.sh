#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <comics|manga>"
  exit 1
}

[[ $# -eq 1 ]] || usage

TYPE="$1"

[[ "$TYPE" == "comics" || "$TYPE" == "manga" ]] || usage

kubectl exec -n books \
  "$(kubectl -n books get pods -l app.kubernetes.io/name=kavita -o jsonpath='{.items[0].metadata.name}')" \
  -- rm -rf "/books/incoming/${TYPE}/.markers"
