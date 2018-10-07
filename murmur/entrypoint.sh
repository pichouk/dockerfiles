#!/bin/bash

CONFIG_FILE="/data/mumble-server.ini"
MAX_BANDWIDTH=${MAX_BANDWIDTH:-128000}
MAX_USERS=${MAX_USERS:-100}

# Copy configuration file if not exists
if [ ! -f $CONFIG_FILE ]
then
  cp /etc/mumble-server.ini $CONFIG_FILE
fi

# Change configuration
sed -i -E "s/^(\/\/ )?database( )?=.*/database=\/data\/murmur.sqlite/g" $CONFIG_FILE
sed -i -E "s/^(\/\/ )?logfile( )?=.*/logfile=/g" $CONFIG_FILE
sed -i -E "s/^(\/\/ )?bandwidth( )?=.*/bandwidth=$MAX_BANDWIDTH/g" $CONFIG_FILE
sed -i -E "s/^(\/\/ )?users( )?=.*/users=$MAX_USERS/g" $CONFIG_FILE

# Set correct rights on murmur files
chown -R mumble-server:mumble-server /data

# Run murmur
murmurd -fg -v -ini $CONFIG_FILE
