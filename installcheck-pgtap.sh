#!/bin/ash
set -ex

if [ -d 'pgtap' ]; then
    cd pgtap
    PGUSER=${POSTGRES_USER:-postgres} make installcheck
    cd /
else
    echo "Skipping `make installcheck` because pgtap repo is gone"
fi
