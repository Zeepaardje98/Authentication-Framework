#!/bin/bash

# Pre-seed debconf with OpenLDAP configuration
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
dpkg-reconfigure -f noninteractive slapd

service slapd start

# slapadd -l /tmp/add_content.ldif -n 1
# slapmodify -l /tmp/map_gssapi_users.ldif -n 0
# slapmodify -l /tmp/update_ACLs.ldif -n 0
# slapmodify -l /tmp/configure_sasl.ldif -n 0 -v -d "-1"
ldapadd -w "$LDAP_PASSWORD" -x -D "cn=admin,$LDAP_DN" -f /tmp/add_content.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/map_gssapi_users.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/update_ACLs.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/configure_sasl.ldif
# ldapmodify -Y EXTERNAL -H ldapi:/// <<EOF
# dn: cn=config
# changetype: modify
# replace: olcLogLevel
# olcLogLevel: 256
# EOF

service slapd stop

# Get kerberos keytab from shared volume
while ! test -f "/tmp/shared_kerberos/$LDAP_SERVICE_HOST.keytab"; do sleep 5; done # Wait for the keytab file
cp /tmp/shared_kerberos/$LDAP_SERVICE_HOST.keytab /etc/krb5.keytab
rm /tmp/shared_kerberos/$LDAP_SERVICE_HOST.keytab
chmod a+rwx /etc/krb5.keytab

klist -k /etc/krb5.keytab

# Authenticate to the KDC, and get kerberos ticket
while ! kinit -k -t "/etc/krb5.keytab" "ldap/$HOSTNAME@$KRB_REALM"; do sleep 20; done

klist -k /etc/krb5.keytab

echo "SETUP FINISHED"