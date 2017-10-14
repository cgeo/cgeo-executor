#! /bin/bash

slave=$(cat /srv/slave)
secret=$(cat /srv/secret)

if [ -z "$slave" -o -z "$secret" ]; then
  echo "You must place credentials for Jenkins in /srv/slave and /srv/secret" 2> /dev/null
  exit 1
fi

if [ -z "$JENKINS_URL" ]; then
  echo "W: Setting JENKINS_URL to default value: http://ci.cgeo.org"
  JENKINS_URL="http://ci.cgeo.org"
fi

wget $JENKINS_URL/jnlpJars/slave.jar -P /tmp/
java -jar /tmp/slave.jar -jnlpUrl $JENKINS_URL/computer/$slave/slave-agent.jnlp -secret $secret
