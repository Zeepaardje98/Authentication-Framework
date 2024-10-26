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
while ! kinit -k -t "/etc/krb5.keytab" "ldap/$HOSTNAME@$KRB_REALM"; do sleep 20; done
klist -A

slapd -d 1

# echo "TEST OPENLDAP RUNNING"
# ldapsearch -x -H ldap://openldap -D "cn=admin,$LDAP_DN" -w $LDAP_PASSWORD -b "$LDAP_DN"


while sleep 60
do
  echo "RUNNING"
done

echo "CONTAINER STOPPED"