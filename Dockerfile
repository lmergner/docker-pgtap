from postgres:9-alpine
MAINTAINER Luke Mergner <lmergner@gmail.com>

ENV PGTAP_VERSION=v0.98.0 POSTGRES_DB=pytest-pgtap

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
