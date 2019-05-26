.PHONY: all build clean list

all: latest

# TODO: build all the major pg versions with latest pgtap
# TODO: sort all the versions highest to lowest

PG_VERSION?=11
PGTAP_VERSION?=v1.0.0

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

latest:
	docker pull postgres:${PG_VERSION}-alpine
	docker build . \
		--no-cache \
		--build-arg PG_VERSION=${PG_VERSION}-alpine \
		--build-arg PGTAP_VERSION=${PGTAP_VERSION} \
		-t lmergner/pgtap:${PG_VERSION}-${PGTAP_VERSION} \
		-t lmergner/pgtap:latest

build:
	docker pull postgres:${PG_VERSION}-alpine
	docker build . \
		--no-cache \
		--build-arg PG_VERSION=${PG_VERSION}-alpine \
		--build-arg PGTAP_VERSION=${PGTAP_VERSION} \
		-t lmergner/pgtap:${PG_VERSION}-${PGTAP_VERSION}

list:
	@python -c "$$GET_VERSIONS"

clean:
	docker rmi $(shell docker image ls -aq lmergner/pgtap) -f
