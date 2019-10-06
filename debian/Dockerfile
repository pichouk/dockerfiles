FROM debian:buster-slim

LABEL fr.kyane.image="registry.kyane.fr/debian"
LABEL maintainer="kyane@kyane.fr"

RUN apt-get update -y \
 && apt-get install -y \
        git \
        curl \
        wget \
        nano \
 && rm -rf /var/lib/apt/lists/*
