#!/usr/bin/env bash
# Запуск на новой Ubuntu VM: sudo bash install-wazuh.sh
set -euo pipefail

apt-get update
apt-get install -y curl ca-certificates

install -d -m 0700 /root/wazuh-install
cd /root/wazuh-install
umask 077
curl -fSL --retry 5 -o wazuh-install.sh \
  https://packages.wazuh.com/4.14/wazuh-install.sh
bash ./wazuh-install.sh -a
