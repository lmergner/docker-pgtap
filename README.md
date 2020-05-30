docker-pgtap
------------

Version 0.0.3

Creates a [Docker][] image with [PostgreSQL][] 12-alpine and [pgTap][] v1.1.0. It inherits from the offical [docker image][].

Note:  it will run the regression tests after docker-postgres creates the files and starts the server. A healthcheck will alert docker when the install has finished and the database is ready to serve.

## Usage with make

`make list` will print a list of versions for the docker postgres image and pgTap releases. These can be supplied as env vars to other `make` commands.

`make build` will build the container.

`make latest` will build the container and tag it as 'latest'.

`make run` will run the container.

`make try` will run the container and remove it afterwards (`--rm`).


All variables can be supplied to `make`:

```
    PG_VERSION=9.5 PGTAP_VERSION=v1.0.0 make build
    POSTGRES_USER=soren_kierkegaard make run
```

Using a .env file and some variety of dotenv makes this pretty easy.

## Build and Run without make

Be sure to check the defaults in the Dockerfile.

```
docker build . -t <repo>/<image>:<tag>
docker run <repo>/<image>:<tag>
```

## Variables


### Docker Build Args

- PG_VERSION
    `make list` will provide acceptable versions. You need to supply the
    `-alpine` if you bypass the Makefile. Note that this Dockerfile is not
    tested with Debian base images.
- PGTAP_VERSION
    `make list` will provide acceptable versions. Note that the 'v' must prefix
    the version number.
- REPO
    Your [Docker namespace](https://docs.docker.com/docker-hub/repos/).
    Default: "lmergner."
- IMAGE_NAME
    Default: pgtap
- IMAGE_TAG
    Default: <PG_VERSION>-<PGTAP_VERSION>

### Postgres ENV Vars

See [the postgres image documentation](https://hub.docker.com/_/postgres) for how the variables are used by the base image.

- CONTAINER_NAME
    default: random docker identifier
- PORT
    default: 5432
- POSTGRES_DB
    default: postgres
- POSTGRES_USER
    The database owner and connection user.
    default: postgres
- POSTGRES_PASSWORD
    The base postgres image requires a password to be set.
    default: postgres

Note:  if you've changed the <repo>/<image>:<tag>, these should also be passed to `make run`.

## Changelog

v0.0.3, May 26 2020

- Update to PostgreSQL 12 and pgTap v1.1.0
- The Dockerfile now accepts password and user ENV variables. These default to postgres, both in the Makefile and the Dockerfile.
- Added `make try` now runs with `--rm`
- CONTAINER_NAME no longer defaults to <PG_VERSION>-<PGTAP_VERSION>, but if ommitted will let docker supply a random identifier.

v0.0.2, May 26 2019

- First functional release. Defaults to pgTap v1.0.0 and PostgreSQL 11.


## Copyright and License

### docker-pgtap

Copyright 2018 by Luke Mergner

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### pgTap

Copyright (c) 2008-2018 David E. Wheeler. Some rights reserved.

Permission to use, copy, modify, and distribute this software and its documentation for any purpose, without fee, and without a written agreement is hereby granted, provided that the above copyright notice and this paragraph and the following two paragraphs appear in all copies.

IN NO EVENT SHALL DAVID E. WHEELER BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF DAVID E. WHEELER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

DAVID E. WHEELER SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND DAVID E. WHEELER HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.



[pgTap]: https://pgtap.org/

[Docker]: https://www.docker.com/

[PostgreSQL]: https://www.postgresql.org/

[docker image]: https://hub.docker.com/_/postgres/
