#!/usr/bin/env bash
set -euo pipefail

kubectl -n books create job "kobo-sync-$(date +%s)" \
  --from="cronjob/kobo-sync"
