#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <comics|manga>"
  exit 1
}

[[ $# -eq 1 ]] || usage

TYPE="$1"

[[ "$TYPE" == "comics" || "$TYPE" == "manga" ]] || usage

kubectl -n books create job "comictagger-${TYPE}-$(date +%s)" \
  --from="cronjob/comictagger-${TYPE}"
