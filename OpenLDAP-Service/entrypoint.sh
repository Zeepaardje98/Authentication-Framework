#!/bin/bash
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"

echo "CONTAINER STARTED"

# ldapsearch -x -H ldap://openldap -b dc=$LDAP_DN -D "cn=admin,$LDAP_DN" -w $LDAP_ADMIN_PASSWORD
# ldapsearch -x -H ldap://openldap:389 -D "cn=admin,dc=external,dc=com" -w adminpassword -b "dc=external,dc=com"

echo "Wait for OpenLDAP server to run"
while ! ldapsearch -x -H ldap://openldap -b "dc=$LDAP_DN" -D "cn=admin,$LDAP_DN" -w "$LDAP_ADMIN_PASSWORD"
do 
  echo "waiting..."
  sleep 5
done
echo "OpenLDAP server running!"

if [ ! -f /$CONTAINER_FIRST_STARTUP ]; then
  touch /$CONTAINER_FIRST_STARTUP

  # Setup
  /tmp/setup.sh
else
  service slapd start
fi

# echo "wait for KDC to run"
# while ! nc -zv kerberos 88 >/dev/null 2>&1;
# do
#   echo "waiting..."
#   sleep 5
# done
# echo "KDC running!"

# /tmp/authenticate.sh

while sleep 60
do
  echo "RUNNING"
done

echo "CONTAINER STOPPED"