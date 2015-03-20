#!/bin/bash
if [ -z "$JENKINS_USER" ]; then
  echo "Please set JENKINS_USER within .secret"
  exit 1
fi

if [ -z "$JENKINS_PASS" ]; then
  echo "Please set JENKINS_PASS within .secret"
  exit 1
fi

if [ -z "$JENKINS_HOME" ]; then
  echo "Please set JENKINS_HOME within .secret"
  exit 1
fi

/usr/bin/java -jar /bin/swarm-client.jar -username $JENKINS_USER -password $JENKINS_PASS -fsroot $JENKINS_HOME/worker/
