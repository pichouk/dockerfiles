FROM debian:stretch-slim

LABEL fr.kyane.image="registry.kyane.fr:5000/debian"
MAINTAINER kyane@kyane.fr

RUN apt-get update -y \
 && apt-get install -y \
        git \
        curl \
        wget \
        nano \
 && rm -rf /var/lib/apt/lists/*
