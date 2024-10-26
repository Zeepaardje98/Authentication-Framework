#!/bin/bash

echo "Authenticating to KDC"

kinit -k -t "/etc/service-sssd.keytab" "sssd/$HOSTNAME.thesis_lan_net@$KRB_REALM"
klist

# sleep 20

# Authenticate to Kerberos (obtain a Kerberos ticket)
echo "$KRB_LDAP_TESTUSER_PASS" | kinit "$KRB_LDAP_TESTUSER_UID@$KRB_REALM"
# echo "Authenticated to KDC!"
klist