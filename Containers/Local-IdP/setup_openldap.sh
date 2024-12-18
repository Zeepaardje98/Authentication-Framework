#!/bin/bash

# echo "Set up OpenLDAP"

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

# # Reconfigure slapd to apply the configuration
# echo "Running dpkg-reconfigure for slapd..."
# dpkg-reconfigure -f noninteractive slapd


echo "Starting slapd if not running..."
# service slapd -h "ldap://IdP-Local-1.web ldapi:///" start

slapd -h "ldap://IdP-Local-1.web ldapi:///" -d 256 &
sleep 10
ldap-schema-manager -i kerberos.schema

# Check that openldap is working
echo "Test OpenLdap working"
ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config dn # Check

# Add Data Replication


# Populate directory
ldapadd -w "$KRB_LDAP_PASSWORD" -x -H ldapi:/// -D "cn=admin,$KRB_LDAP_DN" -f /tmp/setup/add_content.ldif && \
rm /tmp/setup/add_content.ldif

echo "Test added content"
ldapsearch -x -LLL -H ldapi:/// -b "$KRB_LDAP_DN" "(uid=$KRB_LDAP_TESTUSER_UID)" cn gidNumber # Check

# Add index
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/setup/uid_index.ldif && \
rm /tmp/setup/uid_index.ldif
echo "Test added index"
ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b \ cn=config '(olcDatabase={1}mdb)' olcDbIndex # Check

# Add logging
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/setup/logging.ldif && \
rm /tmp/setup/logging.ldif

# service slapd stop

echo "END OPENLDAP SETUP"