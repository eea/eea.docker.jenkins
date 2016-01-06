FROM eeacms/centos:7s
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

RUN \
  yum -y updateinfo && \
  yum -y install \
    java-1.7.0-openjdk \
    xorg-x11-server-Xvfb

RUN curl https://bootstrap.pypa.io/get-pip.py | python3.4 && \
    pip3 install chaperone

ADD chaperone.conf     /etc/chaperone.d/chaperone.conf

#
# Node.js
#
RUN curl -sL https://rpm.nodesource.com/setup | bash -
RUN yum install -y nodejs

# Cleanup cache
RUN yum clean all

#
# XXX Fix me. Install
#
# calibre (ebook-convert)
#

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
RUN curl -o /bin/jenkins-slave.sh -k https://raw.githubusercontent.com/eea/eea.docker.jenkins/master/slave/start.sh
RUN chmod +x /bin/jenkins-slave.sh

# Login as jenkins
ENV HOME $JENKINS_HOME/worker
USER jenkins

# Start
ENTRYPOINT ["/usr/bin/chaperone"]
CMD ["--user", "jenkins"]
