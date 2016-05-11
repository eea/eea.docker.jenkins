# Docker orchestration for EEA Jenkins CI 

Docker orchestration for EEA Jenkins

## Changes

 - [CHANGELOG.md](https://github.com/eea/eea.docker.jenkins/blob/master/CHANGELOG.md)


## Installation

1. Install [Docker](https://www.docker.com/).

2. Install [Docker Compose](https://docs.docker.com/compose/).


## Usage

    $ git clone https://github.com/eea/eea.docker.jenkins.git
    $ cd eea.docker.jenkins
    
Add master, user and password to connect jenkins slaves to jenkins master

    $ cp .secret.example .secret
    $ vi .secret

Also customize your deployment by changing environment variables
See [Supported environment variables](#env) section bellow.

**Before starting you may want to restore existing jenkins configuration**,
jobs and plugins within a data container. See section [Restore existing jenkins configuration](#restore)
for the command to start a data container first.

Below some cluster examples on how to start a master and one or more slaves using docker-compose.
Adjust the cluster composition depending on your jenkins needs.

Start (master only). Do this the first time you run the jenkins cluster.

    $ sudo docker-compose up -d master

Now go to http://localhost:80/configure and configure the JENKINS_URL,
otherwise the [slaves will not be able to connect to the master](https://wiki.jenkins-ci.org/pages/viewpage.action?pageId=60915879).
This is necessary the first time you run the master.

Start (master and 1 slave)

    $ sudo docker-compose up -d

Scale slaves to 3

    $ sudo docker-compose scale worker=3

Check that everything started as expected and the slave successfully connected to master

    $ sudo docker-compose logs worker

See also [Docker orchestration for EEA Jenkins workers able to run Docker related jobs](https://github.com/eea/eea.docker.jenkins.dind)

## Troubleshooting

If the jenkins slaves fail to connect you can either directly provide
`JENKINS_MASTER` env URL within `.secret` file or within your favorite
browser head to `http://<your.jenkins.ip>/configure` and update
`Jenkins URL` property to match your jenkins server IP/DOMAIN (`http://<your.jenkins.ip>/`)
then restart jenkins slaves:

    $ sudo docker-compose restart worker
    $ sudo docker-compose logs worker


## Upgrade

    $ sudo docker-compose pull
    $ sudo docker-compose up -d

## Persistent data as you wish ##
The Jenkins data is kept in a
[data-only container](https://medium.com/@ramangupta/why-docker-data-containers-are-good-589b3c6c749e)
named *data*. The data container keeps the persistent data for a production environment and
[must be backed up](https://github.com/paimpozhil/docker-volume-backup).

So if you are running in a development environment, you can skip the backup and delete
the container if you want.

On a production environment you would probably want to backup the container at regular intervals.

For example, ssh to the host and extract all the data from the container (configuration and jobs history) by using the following command:

    $  docker cp eeadockerjenkins_data_1:/var/jenkins_home /media/backup

The data container can also be easily [copied, moved and be reused between different environments](https://docs.docker.com/userguide/dockervolumes/#backup-restore-or-migrate-data-volumes).

<a name="restore"></a>
### Restore existing jenkins configuration

To setup data container with existing jenkins configuration, jobs and plugins:

    $ docker-compose up master_data
    $ docker run -it --rm --volumes-from eeadockerjenkins_master_data_1 eeacms/jenkins-master:2.0 bash
       $ git clone https://github.com/eea/eea.docker.jenkins.config.git /var/jenkins_home
       $ chown -R 1000:1000 /var/jenkins_home
       $ exit

### Data migration

You can access production data for jenkins inside `master_data` container at:

    /var/jenkins_home

And `worker_data` container at:

    /var/jenkins_home/worker

Thus:

1. Start **rsync client** on host where do you want to migrate `Jenkins master data` (DESTINATION HOST):

  ```
    $ docker run -it --rm --name=r-client --volumes-from=eeadockerjenkins_master_data_1 eeacms/rsync sh
  ```

2. Start **rsync server** on host from where do you want to migrate `Jenkins master data` (SOURCE HOST):

  ```
    $ docker run -it --rm --name=r-server -p 2222:22 --volumes-from=eeadockerjenkins_master_data_1 \
                 -e SSH_AUTH_KEY="<SSH-KEY-FROM-R-CLIENT-ABOVE>" \
             eeacms/rsync server
  ```

3. Within **rsync client** container from step 1 run:

  ```
    $ rsync -e 'ssh -p 2222' -avz --numeric-ids root@<SOURCE HOST IP>:/var/jenkins_home/ /var/jenkins_home/
  ```

4. Start **rsync client** on host where do you want to migrate `Jenkins worker data` (DESTINATION HOST):

  ```
    $ docker run -it --rm --name=r-client --volumes-from=eeadockerjenkins_worker_data_1 eeacms/rsync sh
  ```

5. Start **rsync server** on host from where do you want to migrate `Jenkins worker data` (SOURCE HOST):

  ```
    $ docker run -it --rm --name=r-server -p 2222:22 --volumes-from=eeadockerjenkins_worker_data_1 \
                 -e SSH_AUTH_KEY="<SSH-KEY-FROM-R-CLIENT-ABOVE>" \
             eeacms/rsync server
  ```

6. Within **rsync client** container from step 4 run:

  ```
    $ rsync -e 'ssh -p 2222' -avz --numeric-ids --exclude="workspace" root@<SOURCE HOST IP>:/var/jenkins_home/worker/ /var/jenkins_home/worker/
  ```

<a name="env"></a>
## Supported environment variables

### .secret ###

* `JENKINS_USER` jenkins user to be used to connect slaves to Jenkins master. Make sure that this user has the proper rights to connect slaves and run jenkins jobs.
* `JENKINS_PASS` jenkins user password
* `MTP_USER` postfix user name to be used to login to `MTP_RELAY` (see **postfix.env** bellow)
* `MTP_PASS` postfix password to be used to login to `MTP_RELAY` (see **postfix.env** bellow)

### master.env ###

* `JAVA_OPTS` You might need to customize the JVM running Jenkins master, typically to pass system properties or tweak heap memory settings. Use JAVA_OPTS environment variable for this purpose.
* `JENKINS_OPTS` Start Jenkins with custom options. Useful if you want to start Jenkins on `https` for example.

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
* `JENKINS_OPTS` You can provide multiple parameters via this environment like: `-e JENKINS_OPTS="-labels code-analysis -mode exclusive"`

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
