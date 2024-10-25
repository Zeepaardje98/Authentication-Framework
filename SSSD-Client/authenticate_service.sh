#!/bin/bash

# Get container ID of LDAP Service
while ! (test -f '/container_ids/service-ldap.txt'); do sleep 5; done
ldap_id=$(</container_ids/service-ldap.txt)

# while ! nc -zv openldap 389 >/dev/null 2>&1;
# do
#   sleep 5
# done

# ping openldap
# while ! (ping -c 1 "$ldap_id")
# do
#     sleep 20
# done

echo "Authenticating to Service"
# Perform LDAP search on Service, using kerberos ticket
while ! (ldapsearch -Y GSSAPI -H "ldap://$ldap_id" -b "uid=$KRB_LDAP_TESTUSER_UID,$LDAP_DN")
do
    sleep 60
done
echo "Authenticated to Service!"