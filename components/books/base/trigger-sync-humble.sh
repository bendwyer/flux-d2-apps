#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <bundle-key>"
  exit 1
}

[[ $# -eq 1 ]] || usage

BUNDLE_KEY="$1"

kubectl -n books create job "sync-humble-$(date +%s)" \
  --from="cronjob/sync-humble" \
  --dry-run=client -o yaml | \
  sed "s/CHANGE_ME/${BUNDLE_KEY}/" | \
  kubectl apply -f -
