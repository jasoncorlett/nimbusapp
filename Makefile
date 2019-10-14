.PHONY: build test

build:
	docker build docker -t jasoncorlett/nimbusapp

test:
	./wrapper.sh autopass ps
