#!/bin/bash
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"

echo "CONTAINER STARTED"

if [ ! -f /$CONTAINER_FIRST_STARTUP ]; then
  touch /$CONTAINER_FIRST_STARTUP

  # Add container ID to shared list of IDs
  echo "$HOSTNAME" > /container_ids/identity-provider.txt

  export LDAPSASL_NOCANON=1

  # Run all setup scripts
  for f in /tmp/setup/*.sh; do
    bash "$f" 
  done

  # Setup
  /tmp/setup_openldap.sh
  /tmp/setup_kerberos.sh
fi

nslookup openldap-service.thesis_lan_net
nslookup openldap-service


service slapd start
service krb5-kdc start
service krb5-admin-server start

echo "test kdc running"
netstat -tuln | grep 88

while sleep 60
do
  echo "RUNNING"
done

echo "CONTAINER STOPPED"
