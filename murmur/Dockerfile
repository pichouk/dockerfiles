FROM registry.kyane.fr:5000/debian:latest

LABEL fr.kyane.image="registry.kyane.fr:5000/murmur"
MAINTAINER kyane@kyane.fr

# Install Muble-server
RUN apt-get update -y \
 && apt-get install -y \
      mumble-server \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 64738/tcp 64738/udp

# Volume for persistent storage (config file and database)
VOLUME ["/data"]

# Add entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]