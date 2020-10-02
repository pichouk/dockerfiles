# Murmur

Docker image for a simple Mumble server (Murmur)

## Configuration

Some environment variables allow to configure Murmur at startup :

- `MAX_BANDWIDTH` : integer, maximum bandwidth clients are allowed speech at (default is `128000` bps)
- `MAX_USERS` : integer, maximum number of users on the server (default is `100`)

## Mounted volumes

Murmur store its server database and configuration files under `/data/` folder. You should mount this directory on your host.

## Network

Murmur is listening both TCP and UDP on port 64738. You should bind this container port to your host.
