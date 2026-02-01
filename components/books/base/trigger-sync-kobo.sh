#!/usr/bin/env bash
set -euo pipefail

kubectl -n books create job "sync-kobo-$(date +%s)" \
  --from="cronjob/sync-kobo"
