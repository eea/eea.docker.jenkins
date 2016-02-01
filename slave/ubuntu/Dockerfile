FROM eeacms/ubuntu:14.04
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

RUN pip3 install chaperone \
 && mkdir -p /var/jenkins_home /etc/chaperone.d \
 && useradd -d /var/jenkins_home/worker -u 1000 -m -s /bin/bash jenkins \
 && curl -k -o /bin/swarm-client.jar -k http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.22/swarm-client-1.22-jar-with-dependencies.jar \
 && curl -k -o /etc/chaperone.d/chaperone.conf https://raw.githubusercontent.com/eea/eea.docker.jenkins/master/slave/chaperone.conf

WORKDIR /var/jenkins_home/worker
USER jenkins

# Start
ENTRYPOINT ["/usr/local/bin/chaperone"]
CMD ["--user", "jenkins"]
