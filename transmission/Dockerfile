FROM debian:buster-slim

LABEL fr.kyane.image="registry.kyane.fr/transmission"
LABEL maintainer="kyane@kyane.fr"

RUN apt-get update -y \
 && apt-get install -y \
      transmission-daemon \
      transmission-cli \
      transmission-common \
      jq \
 && rm -rf /var/lib/apt/lists/*

# Add entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
