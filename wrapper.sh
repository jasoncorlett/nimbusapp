#!/bin/bash

docker run \
           --rm \
           -v "$HOME/.nimbusapp:/var/lib/nimbusapp" \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v /var/lib/docker:/var/lib/docker \
           -v "$HOME/.gnupg:/root/.gnupg" \
           -v "$HOME/.password-store:/root/.password-store" \
           -e "http_proxy=${http_proxy}" \
           -e "https_proxy=${https_proxy}" \
           -ti jasoncorlett/nimbusapp:latest "$@"
