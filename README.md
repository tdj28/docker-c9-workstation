# docker-c9-workstation

## What does it do?

Creates a comprehensive ubuntu 14:04 workstation with the Cloud 9 IDE as the interface.

## How do I run it?

### Easiest way

* Install [Docker](https://docs.docker.com/engine/installation/)
* 
```
docker pull doctimjones/c9-linux-workstation
export MY_PATH=/path/to/folder-you-want-to-work-in
export MY_CONTAINER=name-you-want-to-call-running-container
export MY_PORT=9999
docker run -d -p $MY_PORT:9999 -v $MY_PATH:/usr/local/develop \
      --name $MY_CONTAINER doctimjones/c9-linux-workstation
```
* Navigate to [http://localhost:9999](http://localhost:9999)

### docker-composer

* Install [docker-compose](https://github.com/docker/compose/releases)
* clone this repository and `cd` into it
* `cp docker-compose.yml.example-pull docker-compose.yml`
* If you have multiple development directories you'd like to be the focus on their
own c9 containers, you can modify the `docker-compose.yml` file to point to the
development folders and assign unique ports. 
* `docker pull doctimjones/c9-linux-workstation`
* `docker-compose up`
* when compilation is complete, you can point your browser to the separate ports
in separate tabs to have unique dev interfaces, e.g. [http://localhost:9990](http://localhost:9990)

### docker build and run

#### Docker command line

* Install [Docker](https://docs.docker.com/engine/installation/)
* `docker build -t doctimjones/c9-linux-workstation .`
* `docker run -d -p 9999:9999 -v /path/to/folder-you-want-to-work-in:/usr/local/develop --name devdock doctimjones/c9-linux-workstation`
* navigate your web-browser to [http://localhost:9999](http://localhost:9999)

#### Docker compose

* Install [docker-compose](https://github.com/docker/compose/releases)
* clone this repository and modify the Dockerfile and helper files per your needs
* `cp docker-compose.yml.example-build docker-compose.yml`
* If you have multiple development directories you'd like to be the focus on their
own c9 containers, you can modify the `docker-compose.yml` file to point to the
development folders and assign unique ports. 
* `docker-compose up`
* when compilation is complete, you can point your browser to the separate ports
in separate tabs to have unique dev interfaces, e.g. [http://localhost:9990](http://localhost:9990)

## What does it include and how can I change that?

The apt packages and python pips can be found in the packages.txt and requirements.txt respectively.
Simply edit those files before building the container.

## How can I add my ssh key in the container?

Don't! You can mount your .ssh folder as a volume mount (see docker-compose examples in this repo) which keeps you from throwing your keys around in containers/images.
