#!/usr/bin/env bash
# ==============================================================================
# Production Post-Deployment Smoke Test & Health Prober
# Author: Osama Khalil (DevOps Engineer)
# ==============================================================================

set -euo pipefail

TARGET_URL="http://127.0.0.1:8000/healthz"
EXPECTED_STATUS="200"
TIMEOUT_SECS=30
RETRY_INTERVAL=3

while [[ $# -gt 0 ]]; do
  case $1 in
    --target)
      TARGET_URL="$2"
      shift 2
      ;;
    --expected-code)
      EXPECTED_STATUS="$2"
      shift 2
      ;;
    --timeout)
      TIMEOUT_SECS="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

echo "=========================================================="
echo " Starting Post-Deployment Verification Probe"
echo " Target: ${TARGET_URL}"
echo " Expected HTTP Status: ${EXPECTED_STATUS}"
echo " Timeout Window: ${TIMEOUT_SECS} seconds"
echo "=========================================================="

START_TIME=$(date +%s)

while true; do
  CURRENT_TIME=$(date +%s)
  ELAPSED=$(( CURRENT_TIME - START_TIME ))

  if [ "${ELAPSED}" -ge "${TIMEOUT_SECS}" ]; then
    echo "[FAIL] Health probe timed out after ${TIMEOUT_SECS}s."
    exit 1
  fi

  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 -m 5 "${TARGET_URL}" || echo "000")

  if [ "${HTTP_CODE}" == "${EXPECTED_STATUS}" ]; then
    echo "[PASS] Health probe verified! HTTP ${HTTP_CODE} received in ${ELAPSED}s."
    exit 0
  else
    echo "[WAIT] Probe returned HTTP ${HTTP_CODE}. Retrying in ${RETRY_INTERVAL}s... (${ELAPSED}/${TIMEOUT_SECS}s)"
    sleep "${RETRY_INTERVAL}"
  fi
done
