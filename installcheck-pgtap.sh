#!/bin/bash
set -exo pipefail

if [[ "${CI}" == "true" ]]; then
    # Skip installcheck when running on CI because it times out Github Actions healthcheck, we think
    echo "docker-pgtap: Skipping installcheck on CI!"
elif [[ ! -d "/pgtap" ]]; then
    echo "docker-pgtap: Cannot find the /pgtap repo to run make installcheck"
else
    PGUSER="${POSTGRES_USER:-postgres}" make -C /pgtap installcheck
fi
