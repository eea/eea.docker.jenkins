## Jenkins master-slave ready to run Docker image (Jenkins Swarm Plugin)

Docker images for master/slave created to be used for EEA Jenkins.

These images are generic, thus you can obviously re-use them within
your non-related EEA projects.


### Supported tags and respective Dockerfile links

  - jenkins`:master`
  - jenkins`:slave`
  - jenkins`:ubuntu-slave`
  - jenkins`:debian-slave`
  - jenkins`:centos-slave`


### Base docker image

 - https://registry.hub.docker.com/u/eeacms/jenkins/


### Source code

  - http://github.com/eea/eea.docker.jenkins


### Installation

1. Install [Docker](https://www.docker.com/).

2. Install [Docker Compose](https://docs.docker.com/compose/).


### Usage

    $ git clone https://github.com/eea/eea.docker.jenkins.git
    $ cd eea.docker.jenkins

Add user and password to connect jenkins slaves to jenkins master

    $ copy .secret.example .secret
    $ vim .secret

Scale

    $sudo docker-compose scale worker=3

Start

    $ sudo docker-compose up -d


### Alternative usage

You can also build separately master and slaves

Master

    $ cd master
    $ docker-compose up -d

Slave

    $ cd slave
    $ docker-compose up -d

  or

    $ docker-compose scale centos-worker=2 deian-worker=3 ubuntu-worker=5
    $ docker-compose up -d

  or if you want only CentOS workers

    $ cd slave/centos
    $ docker-compose scale worker=5
    $ docker-compose up -d


### Persistent data

In order to persist jenkins conf files and workspaces create a folder called
`jenkins_home` within `/var`

    $ sudo mkdir /var/jenkins_home

And fix permissions

    $ sudo chown -R 1000:docker /var/jenkins_home


## Copyright and license

The Initial Owner of the Original Code is European Environment Agency (EEA).
All Rights Reserved.

The Original Code is free software;
you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later
version.


## Funding

[European Environment Agency (EU)](http://eea.europa.eu)
