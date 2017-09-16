FROM debian:stretch

LABEL fr.kyane.image="registry.kyane.fr/debian"
MAINTAINER kyane@kyane.fr

RUN apt-get update -y \
 && apt-get install -y \
        git \
        curl \
        wget \
        nano

CMD ["/bin/bash"]
