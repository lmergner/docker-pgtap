#!/usr/bin/env bash
set -ex
cd pgtap
PGUSER=${POSTGRES_USER} make installcheck
cd /
