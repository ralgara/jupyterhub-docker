# JupyterHub on Docker


This image is based in the work of https://github.com/twiecki/pydata_docker_jupyterhub

## Build image

Run `docker-compose build`

## Start container

Run `docker-compose up`

The default container configuration assumes shared workbooks are available on the host (see volume mapping in `docker-compose.yml`, set to `/data/docker/jupyterhub` on the host). Shared workbooks are maintained in this repository under `tools/jupyter` - users are advised to synchronize those files upon container restarts to ensure current versions of shared notebooks are made available to Jupyter.

### Generating TLS self-signed certificate

To enable TLS, you must use valid certificates. Self-signed test certificates are maintained alongside sources in this repository, but users assume all associated risks. Instead, we recommend using certificates issued by a proper CA.

`openssl req -newkey rsa:2048 -new -nodes -keyout key.pem -out csr.pem`

`openssl x509 -req -days 365 -in csr.pem -signkey key.pem -out server.crt`

Place this files next to the container's Dockerfile. They will be copied into
the image and referenced by jupyterhub_config.py to configure TLS.
