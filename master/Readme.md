# Jenkins master-slave ready to run Docker image (Jenkins Swarm Plugin)

Docker images for master/slave based on Jenkins Swarm Plugin.

These images are generic, thus you can obviously re-use them within
your non-related EEA projects.


## Supported tags and respective Dockerfile links

### v1.1

- [`:master`, `:master-1.1` (*master/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/master/master/Dockerfile) (default)
- [`:slave`, `:slave-1.1`  (*slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/master/slave/ubuntu/Dockerfile)
- [`:ubuntu-slave`, `:ubuntu-slave-1.1` (*ubuntu-slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/master/slave/ubuntu/Dockerfile)
- [`:debian-slave`, `:debian-slave-1.1`  (*debian-slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/master/slave/debian/Dockerfile)
- [`:centos-slave`, `:centos-slave-1.1` (*centos-slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/master/slave/centos/Dockerfile)

### v1.0

- [`:master-1.0` (*master/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/1.0/master/Dockerfile) (default)
- [`:slave-1.0`  (*slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/1.0/slave/ubuntu/Dockerfile)
- [`:ubuntu-slave-1.0` (*ubuntu-slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/1.0/slave/ubuntu/Dockerfile)
- [`:debian-slave-1.0`  (*debian-slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/1.0/slave/debian/Dockerfile)
- [`:centos-slave-1.0` (*centos-slave/Dockerfile*)](https://github.com/eea/eea.docker.jenkins/blob/1.0/slave/centos/Dockerfile)

## Changes

 - [CHANGELOG.md](https://github.com/eea/eea.docker.jenkins/blob/master/CHANGELOG.md)

## Base docker image

 - [hub.docker.com](https://registry.hub.docker.com/u/eeacms/jenkins)


## Source code

  - [github.com](http://github.com/eea/eea.docker.jenkins)


## Installation

1. Install [Docker](https://www.docker.com/).

2. Install [Docker Compose](https://docs.docker.com/compose/).


## Usage

    $ git clone https://github.com/eea/eea.docker.jenkins.git
    $ cd eea.docker.jenkins
    
### EEA only (checkout EEA branch)

    $ git checkout eea


Add user and password to connect jenkins slaves to jenkins master

    $ cp .secret.example .secret
    $ vi .secret

Also customize your deployment by changing environment variables
within `master.env`, `slave.env` and `postfix.env` files.
See [Supported environment variables](#env) section bellow


**Before starting you may want to restore existing jenkins configuration**,
jobs and plugins within a data container. See section [Restore existing jenkins configuration](#restore) for the command to start a data container first.

Below some cluster examples on how to start a master and one or more slaves using docker-compose. Adjust the cluster composition depending on your jenkins needs.

Start (master only). Do this the first time you run the jenkins cluster.

    $ sudo docker-compose up -d master

Now go to http://localhost:80/configure and configure the JENKINS_URL, otherwise the [slaves will not be able to connect to the master](https://wiki.jenkins-ci.org/pages/viewpage.action?pageId=60915879). This is necessary the first time you run the master.

Start (master and 1 slave)

    $ sudo docker-compose up -d master worker

Scale slaves to 3

    $ sudo docker-compose scale worker=3

Start (debian/centos/ubuntu slaves)

    $ sudo docker-compose up -d centos debian ubuntu

Check that everything started as expected and the slave successfully connected to master

    $ sudo docker-compose logs

## Troubleshooting

If the jenkins slaves fail to connect you can either directly provide
`JENKINS_MASTER` env URL within `slave.env` file or within your favorite
browser head to `http://<your.jenkins.ip>/configure` and update
`Jenkins URL` property to match your jenkins server IP/DOMAIN (`http://<your.jenkins.ip>/`)
then restart jenkins slaves:

    $ sudo docker-compose restart worker
    $ sudo docker-compose logs worker


## Upgrade

    $ sudo docker-compose pull master worker
    $ sudo docker-compose restart master worker

## Persistent data as you wish ##
The Jenkins data is kept in a
[data-only container](https://medium.com/@ramangupta/why-docker-data-containers-are-good-589b3c6c749e)
named *data*. The data container keeps the persistent data for a production environment and
[must be backed up](https://github.com/paimpozhil/docker-volume-backup).

So if you are running in a devel environment, you can skip the backup and delete
the container if you want.

On a production environment you would probably want to backup the container at regular intervals.

For example, ssh to the host and extract all the data from the container (configuration and jobs history) by using the following command:

    $  docker cp eeadockerjenkins_data_1:/var/jenkins_home /media/backup

The data container can also be easily [copied, moved and be reused between different environments](https://docs.docker.com/userguide/dockervolumes/#backup-restore-or-migrate-data-volumes).

<a name="restore"></a>
### Restore existing jenkins configuration

To setup data container with existing jenkins configuration, jobs and plugins:

    $ docker-compose up data
    $ docker run -it --rm --volumes-from eeadockerjenkins_data_1 eeacms/ubuntu \
       /bin/sh -c "git clone https://github.com/eea/eea.docker.jenkins.config.git /var/jenkins_home && chown -R 1000:1000 /var/jenkins_home"


<a name="env"></a>
## Supported environment variables


### .secret ###

* `JENKINS_USER` jenkins user to be used to connect slaves to Jenkins master. Make sure that this user has the proper rights to connect slaves and run jenkins jobs.
* `JENKINS_PASS` jenkins user password
* `MTP_USER` postfix user name to be used to login to `MTP_RELAY` (see **postfix.env** bellow)
* `MTP_PASS` postfix password to be used to login to `MTP_RELAY` (see **postfix.env** bellow)

### master.env ###

* `JAVA_OPTS` You might need to customize the JVM running Jenkins master, typically to pass system properties or tweak heap memory settings. Use JAVA_OPTS environment variable for this purpose.

### slave.env ###

* `JAVA_OPTS` You might need to customize the JVM running Jenkins slave, typically to pass system properties or tweak heap memory settings. Use JAVA_OPTS environment variable for this purpose.
* `JENKINS_NAME` Name of the slave
* `JENKINS_DESCRIPTION` Description to be put on the slave
* `JENKINS_EXECUTORS` Number of executors. Default is equal with the number of available CPUs
* `JENKINS_LABELS` Whitespace-separated list of labels to be assigned for this slave. Multiple options are allowed.
* `JENKINS_RETRY` Number of retries before giving up. Unlimited if not specified.
* `JENKINS_MODE` The mode controlling how Jenkins allocates jobs to slaves. Can be either 'normal' (utilize this slave as much as possible) or 'exclusive' (leave this machine for tied jobs only). Default is normal.
* `JENKINS_MASTER` The complete target Jenkins URL like 'http://jenkins-server'. If this option is specified, auto-discovery will be skipped
* `JENKINS_TUNNEL` Connect to the specified host and port, instead of connecting directly to Jenkins. Useful when connection to Hudson needs to be tunneled. Can be also HOST: or :PORT, in which case the missing portion will be auto-configured like the default behavior
* `JENKINS_TOOL_LOCATIONS` Whitespace-separated list of tool locations to be defined on this slave. A tool location is specified as 'toolName:location'
* `JENKINS_NO_RETRY_AFTER_CONNECTED` Do not retry if a successful connection gets closed.
* `JENKINS_AUTO_DISCOVERY_ADDRESS` Use this address for udp-based auto-discovery (default 255.255.255.255)
* `JENKINS_DISABLE_SSL_VERIFICATION` Disables SSL verification in the HttpClient.

### postix.env ###

* `MTP_HOST` Mail host domain to be used with postfix SMTP only mail server
* `MTP_RELAY` Mail server address/ip to be used to send emails (e.g. smtp.gmail.com. Default None - emails are sent using postfix service within postfix docker image)
* `MTP_PORT` Mail server port to be used to send emails (e.g.: 587. Default: None)


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
