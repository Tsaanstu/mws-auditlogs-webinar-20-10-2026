#!/usr/bin/env bash
# Запуск на Ubuntu VM: sudo bash install-vector.sh
set -euo pipefail

apt-get update
apt-get install -y curl ca-certificates

curl -fSL --retry 5 -o /tmp/vector-setup.sh https://setup.vector.dev
bash /tmp/vector-setup.sh
apt-get update
apt-get install -y vector
