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

Before starting you may want to restore existing jenkins configuration,
jobs and plugins within data container. See `Persistent data as you wish` bellow.

Start (master only)

    $ sudo docker-compose up master (-d)

Add user and password to connect jenkins slaves to jenkins master

    $ copy .secret.example .secret
    $ vim .secret

Start (master and 1 slave)

    $ sudo docker-compose up master worker (-d)

Start (master and 3 slaves)

    $ sudo docker-compose scale worker=3
    $ sudo docker-compose up master worker (-d)

Start (debian/centos/ubuntu slaves)

    $ sudo docker-compose up master centos debian ubuntu (-d)


## Persistent data as you wish ##
The Jenkins data is kept in a
[data-only container](https://medium.com/@ramangupta/why-docker-data-containers-are-good-589b3c6c749e)
named *data*. The data container keeps the persistent data for a production environment and
[must be backed up](https://github.com/paimpozhil/docker-volume-backup).

So if you are running in a devel environment, you can skip the backup and delete
the container if you want.

On a production environment you would probably want to backup the container at regular intervals.
The data container can also be easily
[copied, moved and be reused between different environments](https://docs.docker.com/userguide/dockervolumes/#backup-restore-or-migrate-data-volumes).


To setup data container with existing jenkins configuration, jobs and plugins:

    $ docker-compose up data
    $ docker run -it --rm --volumes-from eeadockerjenkins_data_1 eeacms/linux:ubuntu /bin/sh -c "git clone https://github.com/eea/eea.docker.jenkins.config.git /var/jenkins_home && chown -R 1000:1000 /var/jenkins_home"


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
