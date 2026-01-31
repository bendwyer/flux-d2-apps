#!/usr/bin/env bash
set -euo pipefail

kubectl -n books create job "manga-convert-$(date +%s)" \
  --from="cronjob/manga-convert"
