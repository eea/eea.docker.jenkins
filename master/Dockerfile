FROM jenkins
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
ENV HOME $JENKINS_HOME

USER root
RUN \
  apt-get update && \
  apt-get install -y \
    graphviz \
    npm

RUN rm -rf /var/lib/apt/lists/*
USER jenkins
