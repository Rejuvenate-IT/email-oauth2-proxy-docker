# Email OAuth 2.0 Proxy - Docker
Dockerized Version of [Email OAuth 2.0 Proxy](https://github.com/simonrob/email-oauth2-proxy/) This runs in --no-gui mode.

## Docker Updates
This repository has an automated method that will rebuild the docker container if an issue is opened (see the issues tab). This is to accommodate any changes to the python in on [Email OAuth 2.0 Proxy](https://github.com/simonrob/email-oauth2-proxy/). If this docker image is out of date, please submit that request and it will build automatically.


## Config File Placement
###
The config file should be named `emailproxy.config` and placed in whichever folder you map via Docker Run or Docker Compose.


## Running the email OAuth2 proxy

The email OAuth2 proxy can be run using either Docker compose or Docker run.

### Docker compose

``` yaml
version: '3.7'

services:
  emailproxy:
    image: blacktirion/email-oauth2-proxy-docker # ghcr.io optional. this is published on both Docker Hub and Github Container Repository
    container_name: emailproxy
    volumes:
      /path/to/config:/config
    ports:
      1993:1993
    environment:
      LOGFILE: true
      DEBUG: true
      CACHE_STORE: /config/credstore.config
      LOCAL_SERVER_AUTH: true #Optional
```


This will create a new container with the email OAuth2 proxy and start it. The proxy will be listening on port 1993.

The `volumes` section of the Docker compose file mounts the `/path/to/config` volume into the container. This volume contains the configuration files for the email OAuth2 proxy.

The `ports` section of the Docker compose file exposes port 1993 from the container to the host machine. This is the port that the email OAuth2 proxy listens on.

The `environment` section of the Docker compose file sets the following environment variables in the container:

* `LOGFILE`: Whether or not the email OAuth2 proxy should log to a file.
* `DEBUG`: Whether or not the email OAuth2 proxy should run in debug mode.
* `CACHE_STORE`: The path to the file that the email OAuth2 proxy will use to store its cache. This should always be stored in `/config/<filename>` This is because it needs to write to a persistent storage to keep the tokens. If using AWS Secrets Manager, see the main proxy github for more details.
* `LOCAL_SERVER_AUTH`: Puts the proxy in local server auth mode. See the proxy github for details. Defaults to external auth.

### Docker run

To run the email OAuth2 proxy using Docker run, use the following command:


```
docker run -d \
    --name emailproxy \
    -e DEBUG=false \
    -e CACHE_STORE=/config/credstore.config 
    -e LOGFILE=true \
    -e LOCAL_SERVER_AUTH=true \
    -v /path/to/host/config:/config \
    -p 1993:1993 \
    blacktirion/email-oauth2-proxy-docker
```


This will create a new container with the email OAuth2 proxy and start it. The proxy will be listening on port 1993.

## All Flags and Options
| Type | Flag | Description |
|---|---|---|
|Name| `--name` | The name of the container. |
|Environment| `DEBUG=true` | Enables debug mode in logging. |
|Environment| `LOGFILE=true` | Outputs logs to a file in the config directory. Logs also still stream to docker logging daemon. |
|Environment| `LOCAL_SERVER_AUTH=true` | Puts the proxy in local server auth mode. See the proxy github for details. Defaults to external auth. |
|Environment| `CACHE_STORAGE=<path/to/file or AWS string>` | Allows storing the tokens and secrets in either a separate file or AWS Secrets Manager. If it is a file, it must be /config/<filename>. See the main proxy github for details.|
|Volume| `/path/to/host/config:/config` | Maps the `/config` directory in the container to a local folder/location. |
|Ports| `1993:1993` | Allows the docker daemon to forward all requests to the container on this port. This may change, depending on if you are using POP3 or other proxy methods. This particular method is for IMAP. |
|Ports| `8080:80` | Allows the docker daemon to forward all requests to the container on port 8080 and map to the proxy on port 80. Useful for the `LOCAL_SERVER_AUTH` flag. |
|Image| `ghcr.io/blacktirion/email-oauth2-proxy-docker` or `blacktirion/email-oauth2-proxy-docker` | The location/name of the image. This is published on both Github Container Repository as well as Docker Hub.|
