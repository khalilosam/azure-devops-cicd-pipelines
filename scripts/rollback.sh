#!/usr/bin/env bash
# ==============================================================================
# Automated Production Rollback Utility
# Reverts systemd application release to previous known-good deployment
# Author: Osama Khalil
# ==============================================================================

set -euo pipefail

APP_ROOT="/opt/telecom-nms"
BACKUP_ROOT="/opt/telecom-nms-backups"
SERVICE="nms-api"

echo "=========================================================="
echo " Initiating Automated Rollback Sequence: ${SERVICE}"
echo "=========================================================="

# Check backup archive presence
LATEST_BACKUP=$(ls -td "${BACKUP_ROOT}"/*/ 2>/dev/null | head -1 || true)

if [ -z "${LATEST_BACKUP}" ]; then
  echo "[CRITICAL] No previous deployment snapshot found in ${BACKUP_ROOT}! Manual intervention required."
  exit 2
fi

echo "[INFO] Restoring previous known-good release from: ${LATEST_BACKUP}"
sudo systemctl stop "${SERVICE}"

# Restore backend code
sudo cp -r "${LATEST_BACKUP}/backend"/* "${APP_ROOT}/backend/"
sudo chown -R nmsadmin:nmsadmin "${APP_ROOT}/backend"

# Restart daemon
sudo systemctl daemon-reload
sudo systemctl start "${SERVICE}"

sleep 3
STATUS=$(systemctl is-active "${SERVICE}" || echo "inactive")

if [ "${STATUS}" == "active" ]; then
  echo "[SUCCESS] Rollback complete. Service is running and healthy."
else
  echo "[ERROR] Service failed to recover following rollback. Check journalctl logs."
  sudo journalctl -u "${SERVICE}" -n 30 --no-pager
  exit 1
fi
