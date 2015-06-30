# Nginx for Raspberry Pi 2

This is a Dockerfile to set up [Nginx](http://nginx.org).

This container will run an nginx server with an automatically generated configuration that sets up reverse proxies to other containers.

Dynamically generating configs is possible by exporting the following environment variables:

| Variable     | Description                           |
|--------------|---------------------------------------|
| VIRTUAL_HOST | The host to reverse proxy             |
| VIRTUAL_PORT | The port where the service is running |

# Usage

First, boot up the container you intend to reverse proxy. For example, an [rpi-couchpotato](github.com/nunofgs/rpi-couchpotato) container:

```shell
$ docker run \
  -e "VIRTUAL_HOST=couchpotato.myhost.com"
  -e "VIRTUAL_PORT=5050"
  -v /mnt/data:/data
  nunofgs/rpi-couchpotato
```

Next, start up the *rpi-nginx-proxy* container which will generate the services dynamically:

```shell
$ docker run \
  -p 80:80
  -v /var/run/docker.sock:/tmp/docker.sock:ro
  nunofgs/rpi-nginx-proxy
```

# Thanks

A special thank you to [nginx-proxy](github.com/jwilder/nginx-proxy) which this project is based on.
