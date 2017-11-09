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
    $ docker-compose up -d

Setup Jenkins at [http://localhost]()

* Login as `admin`. Get the generated admin password within master logs:

        $ docker-compose logs master

* Create user `jenkins` with password `jenkins` (or the one you've set within `docker-compose.yml`) in order to allow workers to connect.

        JENKINS_USER: "jenkins"
        JENKINS_PASS: "jenkins"

* To add more Jenkins workers:

        $ sudo docker-compose scale worker=3

* Check that everything started as expected and the slave successfully connected to master:

        $ sudo docker-compose logs worker

<a name="restore"></a>
### Restore existing jenkins configuration



## Production

### Deployment

> **Note:** See **EEA SVN** for `answers.txt` files

* Within `Rancher Catalog > EEA` deploy:
  * `EEA - Jenkins (Master)`
  * `EEA - Jenkins (Worker)`
  * `EEA - Jenkins (EEA Worker)`

* Deploy `EEA - Jenkins (Docker Worker)` with *docker-compose* (recommended)

      $ ssh user@docker-host-1
      $ cd /var/local/deploy
      $ git clone https://github.com/eea/eea.rancher.catalog.git
      $ ln -s eea.rancher.catalog/templates/jenkins-worker-dind jenkins-worker-dind
      $ cd jenkins-worker-dind

* Add deployment environment variables:

      $ vim .env
      $ echo "JENKINS_NAME=docker-$(hostname)" >> .env

* Deploy the latest version (e.g.: `4`):

      $ docker-compose -f 4/docker-compose.yml up -d

### Production data migration

You can access production data for Jenkins Master is within `jenkins-master` volume:

    jenkins-master:/var/jenkins_home

And `jenkins-worker` volumes:

    jenkins-worker:/var/jenkins_home/worker

Thus:

1. Start **rsync client** on host where do you want to migrate `Jenkins master data` (DESTINATION HOST):

  ```
    $ docker run -it --rm --name=r-client -v jenkins-master:/var/jenkins_home  eeacms/rsync sh
  ```

2. Start **rsync server** on host from where do you want to migrate `Jenkins master data` (SOURCE HOST):

  ```
    $ docker run -it --rm --name=r-server -p 2222:22 --v jenkins-master:/var/jenkins_home  \
                 -e SSH_AUTH_KEY="<SSH-KEY-FROM-R-CLIENT-ABOVE>" \
             eeacms/rsync server
  ```

3. Within **rsync client** container from step 1 run:

  ```
    $ rsync -e 'ssh -p 2222' -avz --numeric-ids root@<SOURCE HOST IP>:/var/jenkins_home/ /var/jenkins_home/
  ```

4. Start **rsync client** on host where do you want to migrate `Jenkins worker data` (DESTINATION HOST):

  ```
    $ docker run -it --rm --name=r-client -v jenkins-worker:/var/jenkins_home/worker eeacms/rsync sh
  ```

5. Start **rsync server** on host from where do you want to migrate `Jenkins worker data` (SOURCE HOST):

  ```
    $ docker run -it --rm --name=r-server -p 2222:22 -v jenkins-worker:/var/jenkins_home/worker \
                 -e SSH_AUTH_KEY="<SSH-KEY-FROM-R-CLIENT-ABOVE>" \
             eeacms/rsync server
  ```

6. Within **rsync client** container from step 4 run:

  ```
    $ rsync -e 'ssh -p 2222' -avz --numeric-ids --exclude="workspace" root@<SOURCE HOST IP>:/var/jenkins_home/worker/ /var/jenkins_home/worker/
  ```

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
