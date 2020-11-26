ARG PG_VERSION="13-alpine"

from postgres:${PG_VERSION}


ARG PGTAP_VERSION="v1.1.0"


COPY installcheck-pgtap.sh /docker-entrypoint-initdb.d/
COPY docker-healthcheck /usr/local/bin/

RUN set -ex && \
    apk add --no-cache \
    postgresql \
    postgresql-contrib \
    build-base \
    diffutils \
    git \
    perl && \
    git clone git://github.com/theory/pgtap.git && \
    chown -R postgres:postgres pgtap/ && \
    cd pgtap/ && \
    git checkout tags/${PGTAP_VERSION} && \
    make && make install

LABEL maintainer="lmergner@gmail.com"
LABEL org.opencontainers.image.source https://github.com/lmergner/docker-pytest
LABEL name="docker-pgtap"

HEALTHCHECK CMD [ "docker-healthcheck" ]

# TODO:  figure out how to slim down the size of the image. We can't
#        delete the pgtap/ repo because then we can't run makeinstall
#        when the container inits.
