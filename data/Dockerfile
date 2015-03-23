FROM ubuntu:14.04
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

# Setup JENKINS_HOME
ENV JENKINS_HOME /var/jenkins_home
RUN mkdir -p $JENKINS_HOME
RUN chown -R 1000:1000 $JENKINS_HOME

USER 1000
