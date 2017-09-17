#!/bin/bash

### Transmission configuration file
TRANSMISSION_CONFIG=/etc/transmission-daemon/settings.json

### Some default values
MAX_PEERS_GLOBAL=${MAX_PEERS_GLOBAL:-200}
MAX_PEERS_TORRENT=${MAX_PEERS_TORRENT:-50}
PEER_PORT=${PEER_PORT:-55555}
DHT=${DHT:-no}
LPD=${LPD:-no}
UTP=${UTP:-no}
RPC_PORT=${RPC_PORT:-9091}
RPC_WHITELIST=${RPC_WHITELIST:-127.0.0.1}

## Stopping transmission before changing configuration
# /etc/init.d/transmission-daemon stop

### Build the transmission-daemon command
RUN_CMD="transmission-daemon"
# Directories
RUN_CMD="$RUN_CMD --no-watch-dir --no-incomplete-dir --download-dir /var/lib/transmission-daemon/downloads"
# Other parameters
RUN_CMD="$RUN_CMD  --foreground --log-info  --no-portmap --encryption-preferred"

## Bittorrent config
# Peer port
if [ -n "${PEER_PORT+set}" ]; then
	RUN_CMD="$RUN_CMD --peerport $PEER_PORT"
fi
# DHT
if [ "$DHT" == "yes" ]; then
	RUN_CMD="$RUN_CMD --dht"
else
	RUN_CMD="$RUN_CMD --no-dht"
fi
# LPD
if [ "$LPD" == "yes" ]; then
	RUN_CMD="$RUN_CMD --lpd"
else
	RUN_CMD="$RUN_CMD --no-lpd"
fi
# UTP
if [ "$UTP" == "yes" ]; then
	RUN_CMD="$RUN_CMD --utp"
else
	RUN_CMD="$RUN_CMD --no-utp"
fi

## Limits
# Global peers
if [ -n "${MAX_PEERS_GLOBAL+set}" ]; then
	RUN_CMD="$RUN_CMD --peerlimit-global $MAX_PEERS_GLOBAL"
fi
# Per torrent peers
if [ -n "${MAX_PEERS_TORRENT+set}" ]; then
	RUN_CMD="$RUN_CMD --peerlimit-torrent $MAX_PEERS_TORRENT"
fi

## RPC auth
# Credentials
if [ -n "${RPC_USERNAME+set}" ] && [ -n "${RPC_PASSWORD+set}" ]; then
	RUN_CMD="$RUN_CMD --auth --username $RPC_USERNAME --password $RPC_PASSWORD"
else
	RUN_CMD="$RUN_CMD --no-auth"
fi
# Network
if [ -n "${RPC_PORT+set}" ]; then
	RUN_CMD="$RUN_CMD --port $RPC_PORT"
fi
if [ -n "${RPC_WHITELIST+set}" ]; then
	RUN_CMD="$RUN_CMD --allowed $RPC_WHITELIST"
fi

#
# ### Update configuration file
# ## Base config
# # Max peers
# jq '."max-peers-global" = "'$(MAX_PEERS)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# # Peer port
# jq '."peer-port" = "'$(PEER_PORT)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
#
# ## DHT and PEX
# if [ "$DHT" == "yes" ]; then
# 	jq '."dht-enabled" = 1' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# fi
# if [ "$PEX" == "yes" ]; then
# 	jq '."pex-enabled" = 1' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# fi
#
# ## Limits
# # Download
# if [ -n "${DOWNLOAD_LIMIT+set}" ]; then
# 	jq '."download-limit" = "'$(DOWNLOAD_LIMIT)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# 	jq '."download-limit-enabled" = 1' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# else
# 	jq '."download-limit" = 100' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# 	jq '."download-limit-enabled" = 0' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# fi
# # Upload
# if [ -n "${UPLOAD_LIMIT+set}" ]; then
# 	jq '."upload-limit" = "'$(UPLOAD_LIMIT)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# 	jq '."upload-limit-enabled" = 1' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# else
# 	jq '."upload-limit" = 100' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# 	jq '."upload-limit-enabled" = 0' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# fi
#
# ## RPC auth
# # Credentials
# if [ -n "${RPC_USERNAME+set}" ] && [ -n "${RPC_PASSWORD+set}" ]; then
# 	jq '."rpc-authentication-required" = 1' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# 	jq '."rpc-username" = "'$(RPC_USERNAME)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# 	jq '."rpc-password" = "'$(RPC_PASSWORD)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# fi
# # Network
# jq '."rpc-port" = "'$(RPC_PORT)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
# jq '."rpc-whitelist" = "'$(RPC_WHITELIST)'"' $TRANSMISSION_CONFIG > $TRANSMISSION_CONFIG.tmp && mv $TRANSMISSION_CONFIG.tmp $TRANSMISSION_CONFIG
#
# ## Starting transmission
# /etc/init.d/transmission-daemon start

eval $RUN_CMD
