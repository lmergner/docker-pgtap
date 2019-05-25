.PHONY: all build clean

all: build-latest

build-latest:
	docker pull postgres:11-alpine
	docker build . \
		--no-cache \
		--build-args PG_VERSION=11-alpine \
		--build-args PGTAP_VERSION=v1.0.0 \
		-t lmergner/pgtap:latest
	# TODO: build all the major pg versions with latest pgtap

clean:
	docker rmi $(shell docker image ls -aq lmergner/pgtap) -f
