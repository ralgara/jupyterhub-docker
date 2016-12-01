# JupyterHub on Docker

This container definition provides a fully functional, secure, multiuser server supporting web-based notebooks for data analytics based on the popular [Jupyter](http://jupyter.org/) framework. In its current version, this container supports only Python 3, but efforts are underway to add other popular Jupyter kernels including Python 2, Groovy and Clojure.

## Motivation

Many versions of Jupyter, and its multi-user server, JupyterHub, exist as open source projects and off-the-shelf Docker containers. None of them, however, provide a turnkey solution to easily get test environments running with TLS and user authentication enabled. The central goal of this project is to fill that gap while using minimal dependencies and remaining close to and compatible with the official upstream `jupyter/jupyterhub` image on which this container is based.

## Preparation

### Encryption (TLS)

TLS is required to run this container. Dummy key and certificate files (`key.pem` and `server.crt`) are provided as placeholders in this repository to indicate the target location of these files and allow short-lived tests in secure environments. Be advised that these repository files are public and therefore represent a serious security risk. You are strongly encouraged to replace these files with proper secrets generated according to your security policies.

For testing purposes, you can generate self-signed certificates (assuming the associated risks) using the following commands.

`openssl req -newkey rsa:2048 -new -nodes -keyout key.pem -out csr.pem`

`openssl x509 -req -days 365 -in csr.pem -signkey key.pem -out server.crt`

Place this files next to the container's Dockerfile. They will be copied into
the image and referenced by jupyterhub_config.py to configure TLS.

For production systems, use proper certificates issued by a CA.

### Authentication

The default image uses a simple file database to record users and passwords (WARNING: clear text!). Open source modules by the Jupyter community support OAuth, LDAP and other mechanisms. We are currently working on a LDAP-enabled version of this container.

To customize the user database, simply update the file `users` at the root of this repository.

### Configuration

The full Jupyter configuration is held in `jupyterhub_config.py` at the root of this repository. For details, see http://jupyterhub-tutorial.readthedocs.io/en/latest/ and the official [Jupyter](http://jupyter.org/) website.

## Build image

Run `docker-compose build`

## Start container

Run `docker-compose up`

After startup, the server will be listening by default on port 8000, exposing the standard Jupyter UI.

The default container configuration assumes shared workbooks are available on the host (see volume mapping in `docker-compose.yml`). Simply copy any shared notebooks to `/data/docker/jupyterhub` to make them available to all users.

### Notes

This image is based on the work of Thomas Wiecki (https://github.com/twiecki/pydata_docker_jupyterhub)
