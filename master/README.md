# Jenkins master node

Docker image for EEA jenkins master node


## Requires

* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)


## Getting started

* Get config:

    $ git clone https://github.com/eea/eea.docker.jenkins.git

* Add persistent volume on host:

    $ sudo mkdir /var/jenkins_home

* Optionally add existing jenkins configuration, plugins and jobs:

    $ sudo git clone https://github.com/eea/eea.docker.jenkins.config /var/jenkins_home

* Fix permissions:

    $ sudo chown -R 1000:docker /var/jenkins_home

* Start the app:

    $ sudo docker-compose up -d

* Verify that it works and start customizing jenkins at http://localhost:80
* Add Jenkins workers. See https://github.com/eea/eea.docker.jenkins.slave


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
