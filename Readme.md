## Jenkins master-slave ready to run Docker image (Jenkins Swarm Plugin)

Jenkins master/slave docker images


### Base docker image

 [jenkins](https://registry.hub.docker.com/u/eeacms/jenkins/)

### Docker images

  - jenkins:master
  - jenkins:slave
  - jenkins:ubuntu-slave
  - jenkins:debian-slave
  - jenkins:centos-slave

### Installation

1. Install [Docker](https://www.docker.com/).

2. Install [Docker Compose](https://docs.docker.com/compose/).


### Usage

Default image is ubuntu

    docker-compose up

### Scale

    docker-compose scale worker=3
