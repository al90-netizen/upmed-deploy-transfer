#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${UPMED_TRANSFER_KEY:?کلید انتقال تنظیم نشده است}"

repository_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
incoming=/home/asef/upmed-deploy/incoming
cipher="$repository_dir/upmed-pull-release-20261107-r21.tar.gz.enc"
bundle="$incoming/upmed-pull-release-20261107-r21.tar.gz"

mkdir -p "$incoming"
printf '%s' "$UPMED_TRANSFER_KEY" | openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in "$cipher" -out "$bundle" -pass stdin
unset UPMED_TRANSFER_KEY

cd "$incoming"
echo '81d2422821eba0b18cd438d96c9af7831abaf3878e083b8dd4d0bf0afcc49a3d  upmed-pull-release-20261107-r21.tar.gz' | sha256sum -c -
tar -xzf upmed-pull-release-20261107-r21.tar.gz
chmod 700 deploy-asefweb-20261107-r21.sh
./deploy-asefweb-20261107-r21.sh
