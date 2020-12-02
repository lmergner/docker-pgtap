# docker-pgtap

Version 0.1.0

Pull from the [Docker Hub](https://hub.docker.com/r/lmergner/pgtap).

Creates a [Docker][] image with [PostgreSQL][] and [pgTap][]. It inherits from the
offical PostgreSQL [docker image][], and most of the run-time options can be found
there. To run tests, see the pgTap documentation, especially about `pg_prove` or
my own [pytest-pgtap](https://github.com/lmergner/pytest-pgtap) plugin.

Note: On start, the conainer will run the regression tests after docker-postgres
creates the files and starts the server. A healthcheck will alert docker when the
install has finished and the database is ready to serve.

This image does not install pg_prove. It aims to be a vanilla PostgreSQL image
with the pgTap extension installed.

![Build Matrix](https://github.com/lmergner/docker-pgtap/workflows/build_matrix/badge.svg)

## Image Tags

The `:testing` tag installs the latest stable version of PostgreSQL (currently 13)
and the latest functional version of pgTap. Currently, it installs the "master"
branch because of [a breaking change in PostgreSQL](https://github.com/theory/pgtap/commit/99fdf949b8c3ea157fe078941c6e2af8c7dd7ae8).
Currently equivalent to `:13-master`.

Otherwise, tags represent the postgres and pgtap versions, i.e. \<POSTGRES_VERSION>-\<PGTAP_VERSION>.

## Building with make

`make list` will print a list of versions for the docker postgres image and pgTap releases. These can be supplied
as env vars to other `make` commands.

`make build` will build the container.

`make latest` will build the container and tag it as 'latest'.

`make run` will run the container.

`make try` will run the container and remove it afterwards (`--rm`).

`make psql` will open a local psql connection to the container (i.e. not docker exec).

`make exec` will open an `ash` tty in the container.

All variables can be supplied to `make`:

```sh
    POSTGRES_VERSION=9.5 PGTAP_VERSION=v1.0.0 make build
    POSTGRES_USER=soren_kierkegaard make run
```

Using a .env file and some variety of dotenv makes this pretty easy.

## Variables

### Docker Build Args

These variables will be used by `make` if set in `env`. Or they can be
passed directly to `docker build`.

```sh
docker build --build-args POSTGRES_VERSION=11-alpine --build-args=PGTAP_VERSION=v1.0.0
```

- POSTGRES_VERSION
  `make list` will provide acceptable versions. You need to supply the
  `-alpine` if you bypass the Makefile. Note that this Dockerfile is not
  tested with Debian base images.
- PGTAP_VERSION
  `make list` will provide acceptable versions. Note that the 'v' must prefix
  the version number. You can also supply a branch name like `master`.

### make-specific ENV variables

- REPO
  Your [Docker namespace](https://docs.docker.com/docker-hub/repos/).
  Default: "lmergner."
- IMAGE_NAME
  Default: pgtap
- IMAGE_TAG
  Default: \<POSTGRES_VERSION>-\<PGTAP_VERSION>
- CONTAINER_NAME
  An alias for the container
  default: random docker identifier
- PORT

  default: 5432

### Postgres ENV Vars

See [the postgres image documentation](https://hub.docker.com/_/postgres) for how the variables are used by the base image.

```sh
docker run --env POSTGRES_PASSWORD=blarg --port 5432:5432 -d --name pgtap lmergner/pgtap:11-v1.1.0
```

- POSTGRES_DB
  The default database created on container first run.
  default: postgres
- POSTGRES_USER
  The database owner and connection user.
  default: postgres
- POSTGRES_PASSWORD
  The base postgres image requires a password to be set.

[pgtap]: https://pgtap.org/
[docker]: https://www.docker.com/
[postgresql]: https://www.postgresql.org/
[docker image]: https://hub.docker.com/_/postgres/
