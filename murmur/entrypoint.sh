#!/bin/bash

CONFIG_FILE="/data/mumble-server.ini"
MAX_BANDWIDTH=${MAX_BANDWIDTH:-128000}
MAX_USERS=${MAX_USERS:-100}
BONJOUR_ENABLE=${BONJOUR_ENABLE:-false}
SENDVERSION_ENABLE=${SENDVERSION_ENABLE:-false}
ENABLE_IPV6=${ENABLE_IPV6:-false}

# Copy configuration file if not exists
if [ ! -f $CONFIG_FILE ]
then
  cp /etc/mumble-server.ini $CONFIG_FILE
fi

# Change configuration
sed -i -E "s/^(;.*)?database( )?=.*/database=\/data\/murmur.sqlite/g" $CONFIG_FILE
sed -i -E "s/^(;.*)?logfile( )?=.*/logfile=/g" $CONFIG_FILE
sed -i -E "s/^(;.*)?bandwidth( )?=.*/bandwidth=$MAX_BANDWIDTH/g" $CONFIG_FILE
sed -i -E "s/^(;.*)?users( )?=.*/users=$MAX_USERS/g" $CONFIG_FILE
sed -i -E "s/^(;.*)?bonjour( )?=.*/bonjour=$BONJOUR_ENABLE/g" $CONFIG_FILE
sed -i -E "s/^(;.*)?sendversion( )?=.*/sendversion=$SENDVERSION_ENABLE/g" $CONFIG_FILE

# Enable IPv6
if [ "$ENABLE_IPV6" = true ]
then
  # Enable IPv4 and IPv6, default blank bind all
  sed -i -E "s/^(;.*)?host( )?=.*/host=0.0.0.0,::/g" $CONFIG_FILE
fi

# Run exporter if variable set
if [ -n "$METRICS_SERVER_LABEL" ]
then
  sed -i -E "s/^(;.*)?ice( )?=.*/ice='tcp -h 127.0.0.1 -p 6502'/g" $CONFIG_FILE
  python3 /exporter.py &
fi

# Set correct rights on murmur files
chown -R mumble-server:mumble-server /data

# Trap SIGUSR1 signal to reload certificates without restarting
_reload() {
  echo "Caught SIGUSR1 signal!"
  /usr/bin/pkill -USR1 murmurd
}
trap _term SIGUSR1

# Run murmur
murmurd -fg -v -ini $CONFIG_FILE
