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
    git clone https://gitlab.com/rilian-la-te/musl-locales.git && \
        cd musl-locales && git checkout master && \
        cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && \
        make && make install && \
        cd .. && \
        rm -r musl-locales && \
    git clone git://github.com/theory/pgtap.git && \
        chown -R postgres:postgres pgtap/ && \
        cd pgtap/ && \
        git checkout ${PGTAP_VERSION} && \
        make && make install && \
    apk del .build-dependencies
    # rm -r /pgtap only seems to save 20 mb

LABEL maintainer="lmergner@gmail.com"
LABEL version.release="0.0.4" version.pgtap="${PGTAP_VERSION}" version.postgres="${POSTGRES_VERSION}"
LABEL org.opencontainers.image.source https://github.com/lmergner/docker-pgtap
LABEL name="docker-pgtap"

HEALTHCHECK CMD [ "docker-healthcheck" ]

# TODO:  figure out how to slim down the size of the image. We can't
#        delete the pgtap/ repo because then we can't run makeinstall
#        when the container inits.
