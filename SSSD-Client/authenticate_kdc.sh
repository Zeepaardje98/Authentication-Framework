#!/bin/bash

echo "Authenticating to KDC"

# Authenticate to Kerberos as principal
kinit -k -t "/etc/$SSSD_CLIENT_HOST.keytab" "sssd/$HOSTNAME@$KRB_REALM"

klist