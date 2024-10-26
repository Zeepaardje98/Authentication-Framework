#!/bin/bash

echo "Authenticating to Service"
# Perform LDAP search on Service, using kerberos ticket
while ! (ldapsearch -Y GSSAPI -H "ldap://$LDAP_SERVICE_HOST" -b "$LDAP_DN" -N "ldap/$LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK@$KRB_REALM")
do
    sleep 60
done
echo "Authenticated to Service!"