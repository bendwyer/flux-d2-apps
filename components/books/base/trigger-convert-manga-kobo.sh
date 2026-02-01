#!/usr/bin/env bash
set -euo pipefail

kubectl -n books create job "convert-manga-kobo-$(date +%s)" \
  --from="cronjob/convert-manga-kobo"
