#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <kobo|gutenberg>"
  exit 1
}

[[ $# -eq 1 ]] || usage

SOURCE="$1"

[[ "$SOURCE" == "kobo" || "$SOURCE" == "gutenberg" ]] || usage

kubectl -n books create job "metadata-ebook-${SOURCE}-$(date +%s)" \
  --from="cronjob/metadata-ebook-${SOURCE}"
