#!/bin/bash

echo "Set up OpenLDAP"

# Pre-seed debconf with OpenLDAP configuration
# echo "Pre-seeding slapd configuration..."
# debconf-set-selections <<EOF
# slapd slapd/internal/generated_adminpw password $KRB_LDAP_ADMINPASSWORD
# slapd slapd/internal/adminpw password $KRB_LDAP_ADMINPASSWORD
# slapd slapd/password2 password $KRB_LDAP_PASSWORD
# slapd slapd/password1 password $KRB_LDAP_PASSWORD
# slapd slapd/domain string $KRB_LDAP_DOMAIN
# slapd shared/organization string $KRB_LDAP_ORGANISATION
# slapd slapd/no_configuration boolean false
# slapd slapd/move_old_database boolean true
# slapd slapd/dump_database select when needed
# slapd slapd/allow_ldap_v2 boolean false
# EOF

# Reconfigure slapd to apply the configuration
# echo "Running dpkg-reconfigure for slapd..."
# dpkg-reconfigure -f noninteractive slapd

# service slapd stop
# service slapd start

# ldapadd -v -Y EXTERNAL -H ldapi:/// -f /tmp/set_serverId.ldif

# sleep 5

# slapmodify -b cn=config -l /tmp/set_serverId.ldif

slapd -h "ldap://IdP-Cloud-1.web ldapi:///" -d 256

sleep 5