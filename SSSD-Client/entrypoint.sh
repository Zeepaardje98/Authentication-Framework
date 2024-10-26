#!/bin/bash

# First startup, set up necessary files
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
if [ ! -f /$CONTAINER_FIRST_STARTUP ]; then
  touch /$CONTAINER_FIRST_STARTUP

  # Run all setup scripts
  for f in /tmp/setup/*.sh; do
    bash "$f" 
  done

  /tmp/setup.sh
fi

# Authenticate to the KDC, and get kerberos ticket
while ! nc -zv $KERBEROS_HOST 88 >/dev/null 2>&1; do sleep 5; done
/tmp/authenticate_kdc.sh

# Authenticate to the openldap service, using the kerberos ticket
while ! nc -zv $LDAP_SERVICE_HOST 389 >/dev/null 2>&1;
do
  sleep 5
done
/tmp/authenticate_service.sh


# Container run loop
while sleep 3600
do
  echo "CONTAINER RUNNING"
done

echo "CONTAINER STOPPED"