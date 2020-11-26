.PHONY: all pull latest build stop clean try help run shell

all: latest

# TODO: matrix build all the major pg versions with latest pgtap
# TODO: sort all the versions highest to lowest

REPO?=lmergner
IMAGE_NAME?=pgtap
POSTGRES_VERSION?=13
PGTAP_VERSION?=v1.1.0
IMAGE_TAG?=${POSTGRES_VERSION}-${PGTAP_VERSION}
PORT?=5432


define BUILD
docker build . \
	--no-cache \
	--force-rm \
	--build-arg POSTGRES_VERSION=${POSTGRES_VERSION}-alpine \
	--build-arg PGTAP_VERSION=${PGTAP_VERSION} \
	-t ${REPO}/${IMAGE_NAME}:${IMAGE_TAG}
endef
export BUILD

define RUN
docker run \
	-d \
	-p ${PORT}:5432 \
	$(if $(POSTGRES_PASSWORD),-e POSTGRES_PASSWORD=${POSTGRES_PASSWORD}) \
	$(if $(POSTGRES_USER), -e POSTGRES_USER=${POSTGRES_USER}) \
	$(if $(POSTGRES_DB), -e POSTGRES_DB=${POSTGRES_DB}) \
	$(if $(CONTAINER_NAME), --name ${CONTAINER_NAME}) \
	${REPO}/${IMAGE_NAME}:${IMAGE_TAG}
endef
export RUN

define GET_VERSIONS
import json

try:
    from urllib.request import urlopen, Request
except ImportError:
    from urllib2 import urlopen, Request

urls = {
    "pgtap": "https://api.github.com/repos/theory/pgtap/tags",
    "postgres": "https://hub.docker.com/v2/repositories/library/postgres/tags",
}


for target, url in urls.items():
    req = Request(url)
    req.add_header("Content-Type", "application/json")
    json_resp = json.loads(urlopen(url).read())

    if isinstance(json_resp, dict):
        json_resp = json_resp.get("results")

    print("**** %s" % target)
    for tag in json_resp:
        name = tag.get("name")
        if target == "pgtap" and not name.startswith("v"):
            continue
        print("    %s" % name)
endef
export GET_VERSIONS

.DEFAULT_GOAL := help

pull:  ## pull the postgres:<pg_version>-alpine image
	docker pull postgres:${POSTGRES_VERSION}-alpine

# TODO:  Don't build again, but find ID by filtering and tag after build
latest:  ## Build and tag as 'latest'
	$(BUILD) -t lmergner/pgtap:latest

# TODO:  Don't build if already exists
build:  ## Build the pgtap image
	# docker ps --all --filter name=${CONTAINER_NAME} --format "{{.Names}}")
	$(BUILD)

list:	## pull valid versions for pgTap (from Github) and PostgreSQL (from hub.docker.com)
	## list pgtap and postgres versions which can be supplied
	## as build_args to docker build via pg_version and PGTAP_VERSION
	## make args
	@python -c "$$GET_VERSIONS"

run:    ## run the docker container
	$(RUN)

try:	## run the docker container with --rm
	$(RUN) --rm

# TODO:  filter by tags rather than container name
stop:  ## Stop and remove the container. Defaults to 'pgtap' otherwise supply name as prefix
	-docker stop ${CONTAINER_NAME}

clean: stop  ## remove docker images tagged with <repo>/<image_name>, default lmergner/pgtap
	-docker rm ${CONTAINER_NAME}
	-docker rmi $(shell docker image ls -aq ${REPO}/${IMAGE_NAME}) -f

psql:
	@psql -d postgresql://$${POSTGRES_USER}:$${POSTGRES_PASS}@$${DOCKER_HOST%:*}/$${POSTGRES_DB}

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
