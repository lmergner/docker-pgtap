.PHONY: all pull latest build stop clean

all: latest

# TODO: matrix build all the major pg versions with latest pgtap
# TODO: sort all the versions highest to lowest

REPO?=lmergner
IMAGE_NAME?=pgtap
PG_VERSION?=11
PGTAP_VERSION?=v1.1.0
IMAGE_TAG?=${PG_VERSION}-${PGTAP_VERSION}
CONTAINER_NAME?=${IMAGE_NAME}_${IMAGE_TAG}
PORT?=5432

define BUILD
docker build . \
	--no-cache \
	--force-rm \
	--build-arg PG_VERSION=${PG_VERSION}-alpine \
	--build-arg PGTAP_VERSION=${PGTAP_VERSION} \
	-t ${REPO}/${IMAGE_NAME}:${IMAGE_TAG}
endef
export BUILD

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

pull:
	docker pull postgres:${PG_VERSION}-alpine

latest:
	$(BUILD) -t lmergner/pgtap:latest

build:  ## Build the pgtap image
	$(BUILD)

list:
	## retrieve pgtap and postgres versions which can be supplied
	## as build_args to docker build via PG_VERSION and PGTAP_VERSION
	## make args
	@python -c "$$GET_VERSIONS"

run:    ## run the docker container
	docker run \
		-d \
		--name ${CONTAINER_NAME} \
		-p ${PORT}:5432 \
		$(if $(POSTGRES_USER), -e POSTGRES_USER=${POSTGRES_USER}) $(if $(POSTGRES_DB), -e POSTGRES_DB=${POSTGRES_DB}) ${REPO}/${IMAGE_NAME}:${IMAGE_TAG}

stop:
	docker stop ${CONTAINER_NAME}
	docker rm ${CONTAINER_NAME}

clean: stop  ## Remove docker images tagged with lmergner/pgtap
	docker rmi $(shell docker image ls -aq ${REPO}/${IMAGE_NAME}) -f
