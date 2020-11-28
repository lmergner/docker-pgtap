# Changelog

## [unreleased]

- Don't run `make installcheck` when in CI environment

## v0.1.0, Nov 27 2020

`:latest` now builds PostgreSQL 13 and from pgTap master.

- Add Github Actions to build and push to Docker Hub and Github Container Registry
- Published builds for multiple versions of PostgreSQL and pgTap
- Remove PostgreSQL image ENV variables from Dockerfile and Makefile build

## v0.0.4, Nov 26 2020

- Fix build error caused by missing `patch` in newer versions of alpine base image.
- Update PostgreSQL to 13.

## v0.0.3, May 26 2020

- Update to PostgreSQL 12 and pgTap v1.1.0
- The Dockerfile now accepts password and user ENV variables. These default to postgres, both in the Makefile and the Dockerfile.
- Added `make try` now runs with `--rm`
- CONTAINER_NAME no longer defaults to <PG_VERSION>-<PGTAP_VERSION>, but if ommitted will let docker supply a random identifier.

## v0.0.2, May 26 2019

- First functional release. Defaults to pgTap v1.0.0 and PostgreSQL 11.
