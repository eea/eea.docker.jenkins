FROM eeacms/linux:debian
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

RUN \
  apt-get update && \
  apt-get install -y openjdk-7-jdk

# Cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*

# Set JENKINS_HOME same as master
ENV JENKINS_HOME /var/jenkins_home

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/volume from a data container,
# ensure you use same uid
RUN mkdir -p $JENKINS_HOME
RUN useradd -d "$JENKINS_HOME/worker" -u 1000 -m -s /bin/bash jenkins

# Jenkins home directoy is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

# Add swarm-client
COPY ../swarm-client-1.22-jar-with-dependencies.jar /bin/swarm-client.jar
COPY ../start.sh /bin/jenkins-slave.sh

# Login as jenkins
ENV HOME $JENKINS_HOME/worker
USER jenkins

# Start
CMD /bin/jenkins-slave.sh
