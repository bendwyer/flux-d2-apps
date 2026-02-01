#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <bundle-key> <comics|manga>"
  exit 1
}

[[ $# -eq 2 ]] || usage

BUNDLE_KEY="$1"
TYPE="$2"

[[ "$TYPE" == "comics" || "$TYPE" == "manga" ]] || usage

kubectl -n books create job "sync-humble-${TYPE}-$(date +%s)" \
  --from="cronjob/sync-humble-${TYPE}" \
  --dry-run=client -o yaml | \
  sed "s/CHANGE_ME/${BUNDLE_KEY}/" | \
  kubectl apply -f -
