# docker-c9-workstation

## What does it do?

Creates a comprehensive ubuntu 14:04 workstation with the Cloud 9 IDE as the interface.

## How do I run it?

### Easiest way

* Install [docker-compose](https://github.com/docker/compose/releases)
* `docker pull doctimjones/c9-linux-workstation`
* `docker run -d -p 9999:9999 -v /path/to/folder-you-want-to-work-in:/usr/local/develop --name devdock doctimjones/c9-linux-workstation`
* Navigate to [http://localhost:9990](http://localhost:9990)

### docker-composer

* Install [docker-compose](https://github.com/docker/compose/releases)
* clone this repository and `cd` into it
* `cp docker-compose.yml.example docker-compose.yml`
* If you have multiple development directories you'd like to be the focus on their
own c9 containers, you can modify the `docker-compose.yml` file to point to the
development folders and assign unique ports. 
* `docker-compose up`
* when compilation is complete, you can point your browser to the separate ports
in separate tabs to have unique dev interfaces, e.g. [http://localhost:9990](http://localhost:9990)

### docker build and run

* Install [Docker](https://docs.docker.com/engine/installation/)
* `docker build -t c9-only .`
* `docker run -d -p 9999:9999 -v /path/to/folder-you-want-to-work-in:/usr/local/develop --name devdock c9-only`
* navigate your web-browser to [http://localhost:9999](http://localhost:9999)

## What does it include and how can I change that?

The apt packages and python pips can be found in the packages.txt and requirements.txt respectively.
Simply edit those files before building the container.

## How can I add my ssh key in the container?

We turn this off by default as this is [potentially dangerous](https://github.com/docker/docker/issues/6396), however, 
you can add the following lines to the Docker container just above the final 
`CMD` line:

```
ARG SSH_KEY
RUN mkdir -p /root/.ssh && \
  echo "$SSH_KEY" >/root/.ssh/id_rsa && \
  chmod 0600 /root/.ssh/id_rsa
```

and then build with 

```
docker build -t c9-only --build-arg SSH_KEY="$(cat ~/.ssh/id_rsa) .
```
