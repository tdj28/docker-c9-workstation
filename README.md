# docker-c9-workstation

## What does it do?

Creates a comprehensive ubuntu 14:04 workstation with the Cloud 9 IDE as the interface.

## How do I run it?

* Install [Docker](https://docs.docker.com/engine/installation/)
* `docker build -t c9-only .`
* `docker run -d -p 9999:9999 -v /path/to/folder-you-want-to-work-in:/usr/local/develop --name devdock c9-only`
* navigate your web-browser to [http://localhost:9999](http://localhost:9999)

## What does it include and how can I change that?

The apt packages python pips can be found in the packages.txt and requirments.txt respectively.
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
