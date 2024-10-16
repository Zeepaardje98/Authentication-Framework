#!/bin/bash

# Configuration
# OPENLDAP_HOST="ldap-server.myorganization.com"  # Replace with your OpenLDAP server hostname or IP
# LDAP_BASE_DN="dc=myorganization,dc=com"  # Your LDAP base DN
# LDAP_USER="cn=admin,$LDAP_BASE_DN"  # Your LDAP admin or user DN

echo "Authenticating to Kerberos..."

# Ensure the Kerberos configuration file is set up correctly (usually /etc/krb5.conf)
echo "Using Kerberos realm: $KRB_REALM"
echo "Using Kerberos principal: $KRB_LDAP_TESTUSER_UID@$KRB_REALM"
echo "Using Kerberos KDC: $KRB_KDC_IP"
# echo "Using OpenLDAP server: $OPENLDAP_HOST"

# Authenticate to Kerberos (obtain a Kerberos ticket)
while ! (echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$KRB_LDAP_TESTUSER_UID@$KRB_REALM")
do
    echo "Authentication failed"
    sleep 5
    echo "Re-Attempting authentication"
done

echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$KRB_LDAP_TESTUSER_UID@$KRB_REALM"
klist

# Perform LDAP search on Kerberos Service, to test kerberos working
# ldapsearch -H "ldap://openldap.$LDAP_DOMAIN" -Y GSSAPI -b "$LDAP_DN"