#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${UPMED_TRANSFER_KEY:?کلید انتقال تنظیم نشده است}"

repository_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
incoming=/home/asef/upmed-deploy/incoming
cipher="$repository_dir/upmed-pull-release-20261107-r21.1.tar.gz.enc"
bundle="$incoming/upmed-pull-release-20261107-r21.1.tar.gz"

mkdir -p "$incoming"
printf '%s' "$UPMED_TRANSFER_KEY" | openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in "$cipher" -out "$bundle" -pass stdin
unset UPMED_TRANSFER_KEY

cd "$incoming"
echo 'c1460bf252fa4faa7e8268901c64cc900f1c972a1942590fba7df98311bf58fc  upmed-pull-release-20261107-r21.1.tar.gz' | sha256sum -c -
tar -xzf upmed-pull-release-20261107-r21.1.tar.gz
chmod 700 deploy-asefweb-20261107-r21.1.sh
./deploy-asefweb-20261107-r21.1.sh
