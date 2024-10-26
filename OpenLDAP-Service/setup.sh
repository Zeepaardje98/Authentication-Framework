#!/bin/bash

echo "Set up OpenLDAP"

# Pre-seed debconf with OpenLDAP configuration
echo "Pre-seeding slapd configuration..."
debconf-set-selections <<EOF
slapd slapd/internal/generated_adminpw password $LDAP_ADMINPASSWORD
slapd slapd/internal/adminpw password $LDAP_ADMINPASSWORD
slapd slapd/password2 password $LDAP_PASSWORD
slapd slapd/password1 password $LDAP_PASSWORD
slapd slapd/domain string $LDAP_DOMAIN
slapd shared/organization string $LDAP_ORGANISATION
slapd slapd/no_configuration boolean false
slapd slapd/move_old_database boolean true
slapd slapd/dump_database select when needed
slapd slapd/allow_ldap_v2 boolean false
EOF
# Reconfigure slapd to apply the configuration
echo "Running dpkg-reconfigure for slapd..."
dpkg-reconfigure -f noninteractive slapd

# echo "Starting slapd if not running..."
service slapd start

# ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/update_ACLs.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/configure_sasl.ldif

# Configure OpenLDAP to support GSSAPI
# echo "BASE    dc=external,dc=com
# URI     ldap://openldap.external.com
# SASL_MECH GSSAPI
# SASL_REALM EXAMPLE.COM
# SASL_HOST openldap-service.thesis_lan_net
# SASL_NOCANON on" >> /etc/ldap/ldap.conf

# Configure SASL to use a keytab
# cat > /etc/ldap/sasl2/slapd.conf <<EOF
# mech_list: GSSAPI
# keytab: /etc/ldap/ldap.keytab
# EOF


# Get kerberos keytab from shared volume
while ! test -f "/tmp/shared_kerberos/$LDAP_SERVICE_HOST.keytab"; do sleep 5; done # Wait for file to be available
cp /tmp/shared_kerberos/$LDAP_SERVICE_HOST.keytab /etc/krb5.keytab
rm /tmp/shared_kerberos/$LDAP_SERVICE_HOST.keytab
chmod a+rwx /etc/krb5.keytab

# klist

# Add logging
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/logging.ldif

echo "TEST LOGGING LEVEL"
ldapsearch -Y EXTERNAL -H ldapi:/// -b "cn=config" olcLogLevel

# Restart openldap to apply configuration
service slapd stop

# ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/update_ACLs.ldif

echo "END OPENLDAP SETUP"