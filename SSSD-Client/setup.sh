#!/bin/bash

# Get kerberos keytab from shared volume
while ! test -f "/tmp/shared_kerberos/$SSSD_CLIENT_HOST.keytab"; do sleep 5; done # Wait for file to be available
cp /tmp/shared_kerberos/$SSSD_CLIENT_HOST.keytab /etc/$SSSD_CLIENT_HOST.keytab
rm /tmp/shared_kerberos/$SSSD_CLIENT_HOST.keytab
chmod a+rwx /etc/$SSSD_CLIENT_HOST.keytab