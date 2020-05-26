ARG PG_VERSION="12-alpine"

from postgres:${PG_VERSION}

LABEL maintainer="lmergner@gmail.com"
LABEL version="0.0.3"

ARG PGTAP_VERSION="v1.1.0"
ENV PGTAP_VERSION=${PGTAP_VERSION}
ENV POSTGRES_PASSWORD=postgres

COPY installcheck-pgtap.sh /docker-entrypoint-initdb.d/
COPY docker-healthcheck /usr/local/bin/

RUN set -ex && \
    apk add --no-cache \
    bash \
    postgresql \
    postgresql-contrib \
    make \
    diffutils \
    git \
    perl && \
    git clone git://github.com/theory/pgtap.git && \
    chown -R postgres:postgres pgtap/ && \
    cd pgtap/ && \
    git checkout tags/${PGTAP_VERSION} && \
    make && make install

HEALTHCHECK CMD [ "docker-healthcheck" ]

# TODO:  figure out how to slim down the size of the image. We can't
#        delete the pgtap/ repo because then we can't run makeinstall
#        when the container inits.
