FROM eeacms/ubuntu:14.04
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

RUN \
  apt-get update && \
  apt-get install -y \
    openjdk-7-jdk \
    calibre \
    xvfb \
    npm

# Cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*

# Set JENKINS_HOME same as master
ENV JENKINS_HOME /var/jenkins_home

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/volume from a data container,
# ensure you use same uid
RUN mkdir -p $JENKINS_HOME
RUN useradd -d "$JENKINS_HOME/worker" -u 1000 -m -s /bin/bash jenkins

# Add swarm-client
RUN curl -o /bin/swarm-client.jar -k http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.22/swarm-client-1.22-jar-with-dependencies.jar

# Add start script
RUN curl -o /bin/jenkins-slave.sh -k https://raw.githubusercontent.com/eea/eea.docker.jenkins/1.0/slave/start.sh
RUN chmod +x /bin/jenkins-slave.sh

# Login as jenkins
ENV HOME $JENKINS_HOME/worker
USER jenkins

# Start
CMD /bin/jenkins-slave.sh
