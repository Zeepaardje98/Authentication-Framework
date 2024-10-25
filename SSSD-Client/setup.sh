#!/bin/bash

# Get kerberos keytab from shared volume
while ! test -f "/tmp/shared2/service-sssd.keytab"; do sleep 5; done # Wait for file to be available
cp /tmp/shared2/service-sssd.keytab /etc/service-sssd.keytab
# rm /tmp/shared2/service-sssd.keytab
chmod a+rwx /etc/service-sssd.keytab

# Configure support GSSAPI
# echo "BASE    dc=external,dc=com
# URI     ldap://openldap
# SASL_MECH GSSAPI
# SASL_REALM EXAMPLE.COM" >> /etc/ldap/ldap.conf