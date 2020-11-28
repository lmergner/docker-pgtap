ARG POSTGRES_VERSION="13-alpine"
ARG PGTAP_VERSION="v1.1.0"

from postgres:${POSTGRES_VERSION}

COPY installcheck-pgtap.sh /docker-entrypoint-initdb.d/
COPY docker-healthcheck /usr/local/bin/
COPY create-extension.sql /docker-entrypoint-initdb.d/

# TODO: move musl-locale to a builder image
# TODO: move pgtap to a builder image
RUN set -ex && \
    apk add --no-cache make && \
    apk add --no-cache --virtual .build-dependencies \
    cmake make musl-dev gcc gettext-dev libintl \
    postgresql \
    postgresql-contrib \
    build-base \
    patch \
    diffutils \
    git \
    perl && \
    git clone git://github.com/theory/pgtap.git && \
        chown -R postgres:postgres pgtap/ && \
        cd pgtap/ && \
        git checkout ${PGTAP_VERSION} && \
        make && make install && \
    apk del .build-dependencies

LABEL maintainer="lmergner@gmail.com"
LABEL version.release="0.1.0" version.pgtap="${PGTAP_VERSION}" version.postgres="${POSTGRES_VERSION}"
LABEL org.opencontainers.image.source https://github.com/lmergner/docker-pgtap
LABEL org.opencontainers.image.authors "Luke Mergner <lmergner@gmail.com>"
LABEL org.opencontainers.image.version="0.1.0"
LABEL org.opencontainers.image.title="docker-pgtap" name="docker-pgtap"

HEALTHCHECK CMD [ "docker-healthcheck" ]

# TODO:  figure out how to slim down the size of the image. We can't
#        delete the pgtap/ repo because then we can't run makeinstall
#        when the container inits.
#        rm -r /pgtap only seems to save 20 mb
