# Transmission

Docker image for a simple transmission server

## Configuration
Some environment variables allow to configure transmission at startup :
- `MAX_PEERS_GLOBAL` : integer, number of global peers (default is `200`)
- `MAX_PEERS_TORRENT` : integer, number of peers per torrent (default is `50`)
- `DHT` : `yes` will enable DHT (disabled by default)
- `LPD` : `yes` will enable LPD (disabled by default)
- `UTP` : `yes` will enable UTP (disabled by default)

### Authentication
To enable RPC authentication, you have to configure 2 environment variables :
- `RPC_USERNAME` : username
- `RPC_PASSWORD` : password

2 other variables can be used to customize configuration of RPC :
- `RPC_PORT` : port to listen on (default is `9091`)
- `RPC_WHITELIST` : authorized source IP addresses (default is `127.0.0.1`)

## Mounted volumes
Transmission store all torrents data under `/var/lib/transmission-daemon/downloads`. You should mount this directory on your host.
