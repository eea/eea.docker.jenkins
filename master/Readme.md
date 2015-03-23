## Jenkins master-slave ready to run Docker image (Jenkins Swarm Plugin)

Docker images for master/slave created to be used for EEA Jenkins.

These images are generic, thus you can obviously re-use them within
your non-related EEA projects.


### Supported tags and respective Dockerfile links

  - `:master` (default)
  - `:slave`
  - `:ubuntu-slave`
  - `:debian-slave`
  - `:centos-slave`


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

Optionally add existing jenkins configuration. See `Persistent data` section
bellow.

Scale

    $sudo docker-compose scale worker=3

Start

    $ sudo docker-compose up -d


### Alternative usage

You can also build separately master and slaves

Master

    $ cd master
    $ sudo docker-compose up -d

Slave

    $ cd slave
    $ sudo docker-compose up -d

  or

    $ sudo docker-compose scale centos=2 deian=3 ubuntu=5
    $ sudo docker-compose up -d

  or if you want only CentOS workers

    $ cd slave/centos
    $ sudo docker-compose scale worker=5
    $ sudo docker-compose up -d


### Persistent data

In order to persist jenkins conf files and workspaces create a folder called
`jenkins_home` within `/var`

    $ sudo mkdir /var/jenkins_home

Optionally add existing jobs and plugins configuration

    $ sudo git clone https://github.com/eea/eea.docker.jenkins.config.git

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
