.PHONY: all build clean

all: build

build:
	docker pull postgres:11-alpine
	docker build . \
		--no-cache \
		-t lmergner/pgtap:latest

clean:
	docker rmi $(shell docker image ls -aq lmergner/pgtap) -f
