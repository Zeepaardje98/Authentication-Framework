#!/bin/bash

echo "Authenticating to KDC"

# Authenticate to Kerberos as principal
kinit -k -t "/etc/$SSSD_CLIENT_HOST.keytab" "sssd/$HOSTNAME.$ON_PREMISES_NETWORK@$KRB_REALM"
klist

# Authenticate to Kerberos as user (obtain a Kerberos ticket)
echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$KRB_LDAP_TESTUSER_UID@$KRB_REALM"
klist