#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${UPMED_TRANSFER_KEY:?کلید انتقال تنظیم نشده است}"

repository_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
incoming=/home/asef/upmed-deploy/incoming
cipher="$repository_dir/upmed-pull-release-20261110-r22.tar.gz.enc"
bundle="$incoming/upmed-pull-release-20261110-r22.tar.gz"

mkdir -p "$incoming"
printf '%s' "$UPMED_TRANSFER_KEY" | openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in "$cipher" -out "$bundle" -pass stdin
unset UPMED_TRANSFER_KEY

cd "$incoming"
echo 'b578feb95dac570e46e66b9e29e3831fe949ddf1e2ab59fabb3a99643a5aa3b4  upmed-pull-release-20261110-r22.tar.gz' | sha256sum -c -
tar -xzf upmed-pull-release-20261110-r22.tar.gz
chmod 700 deploy-asefweb-20261110-r22.sh
./deploy-asefweb-20261110-r22.sh
