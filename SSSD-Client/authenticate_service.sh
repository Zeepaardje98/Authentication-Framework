#!/bin/bash

echo "Authenticating to Service"
# Perform LDAP search on Service, using kerberos ticket
echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$KRB_LDAP_TESTUSER_UID@$KRB_REALM"

while ! (ldapwhoami -Y GSSAPI -H "ldap://$LDAP_SERVICE_HOST")
do
    sleep 20
done

# while ! (ldapsearch -Y GSSAPI -H "ldap://$LDAP_SERVICE_HOST" -b "ou=Groups,$LDAP_DN" \
#         -N "ldap/$LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK@$KRB_REALM")
# do
#     sleep 20
# done

# Get Groups this user is a member of
# while ! (ldapsearch -Y GSSAPI -H "ldap://$LDAP_SERVICE_HOST" -b "ou=Groups,$LDAP_DN" "(member=uid=$KRB_LDAP_TESTUSER_UID,ou=People,$LDAP_DN)" cn \
#         -N "ldap/$LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK@$KRB_REALM")
# do
#     sleep 20
# done

echo "Authenticated to Service!"