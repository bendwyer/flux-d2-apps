#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <comics|manga> <bundle-name>"
  exit 1
}

[[ $# -eq 2 ]] || usage

TYPE="$1"
BUNDLE_NAME="$2"

[[ "$TYPE" == "comics" || "$TYPE" == "manga" ]] || usage

kubectl -n books create job "convert-${TYPE}-humble-$(date +%s)" \
  --from="cronjob/convert-${TYPE}-humble" \
  --dry-run=client -o yaml | \
  sed "s/CHANGE_ME/${BUNDLE_NAME}/" | \
  kubectl apply -f -
