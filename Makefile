.PHONY: build clean all

all: build

build:
	docker build . \
		--no-cache \
		-t lmergner/pgtap:latest \
 		-t lmergner/pgtap:9-alpine

clean:
	docker image prune -f
	# docker rmi $(docker images --filter "dangling=true" --quiet)
