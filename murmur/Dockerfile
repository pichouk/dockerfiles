FROM debian:buster-slim

LABEL fr.kyane.image="registry.kyane.fr/murmur"
LABEL maintainer="kyane@kyane.fr"

# Install Mumble server
RUN apt-get update -y \
   && apt-get dist-upgrade -y \
   && apt-get install -y \
     python3 \
     python3-pip \
     libssl-dev \
     libbz2-dev \
     mumble-server=1.3.0~git20190125.440b173+dfsg-2 \
     zeroc-ice-slice \
   && rm -rf /var/lib/apt/lists/*

# Install prometheus exporter and Python dependencies
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r requirements.txt
COPY exporter.py /

EXPOSE 64738/tcp 64738/udp

# Volume for persistent storage (config file and database)
VOLUME ["/data"]

# Add entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
