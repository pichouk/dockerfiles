FROM registry.kyane.fr:5000/debian:latest

LABEL fr.kyane.image="registry.kyane.fr:5000/transmission"
MAINTAINER kyane@kyane.fr

RUN apt-get update -y \
 && apt-get install -y \
        transmission-daemon \
				transmission-cli \
				transmission-common \
				jq

# Add entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
