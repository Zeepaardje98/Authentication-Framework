#!/bin/bash

# Start OpenLDAP in the background
echo "Set up Kerberos"

## STEP 1: SET UP KERBEROS WITH EXISTING OPENLDAP AS BACK-END ##

service slapd start

ldap-schema-manager -i kerberos.schema

# Add Index
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/krbPrincipalName_index.ldif

# Add kerberos administrative entities
ldapadd -w "$KRB_LDAP_PASSWORD" -x -D "cn=admin,$KRB_LDAP_DN" -f /tmp/add_kerberos_entities.ldif
ldappasswd -w "$KRB_LDAP_PASSWORD" -x -D "cn=admin,$KRB_LDAP_DN" "uid=kdc-service,$KRB_LDAP_DN" -s "$KRB_KDC_PASSWORD"
ldappasswd -w "$KRB_LDAP_PASSWORD" -x -D "cn=admin,$KRB_LDAP_DN" "uid=kadmin-service,$KRB_LDAP_DN" -s "$KRB_ADMIN_PASSWORD"

# Test kdc service and admin users
ldapwhoami -w "$KRB_KDC_PASSWORD" -x -D "uid=kdc-service,$KRB_LDAP_DN"
ldapwhoami -w "$KRB_ADMIN_PASSWORD" -x -D "uid=kadmin-service,$KRB_LDAP_DN"

# Update ACLs
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/update_ACLs.ldif

# Replace krb5.conf
cp /tmp/krb5.conf /etc/krb5.conf

# Create kerberos realm
kdb5_ldap_util -D "cn=admin,$KRB_LDAP_DN" -w "$KRB_LDAP_PASSWORD" -H ldapi:/// create -P "$DB_PASS" -subtrees "$KRB_LDAP_DN" -s -r "$KRB_REALM"

# Create password stashes
yes $KRB_KDC_PASSWORD | kdb5_ldap_util -D "cn=admin,$KRB_LDAP_DN" -w "$KRB_LDAP_PASSWORD" -H ldapi:/// stashsrvpw -f /etc/krb5kdc/service.keyfile "uid=kdc-service,$KRB_LDAP_DN"
yes $KRB_ADMIN_PASSWORD | kdb5_ldap_util -D "cn=admin,$KRB_LDAP_DN" -w "$KRB_LDAP_PASSWORD" -H ldapi:/// stashsrvpw -f /etc/krb5kdc/service.keyfile "uid=kadmin-service,$KRB_LDAP_DN"

# Create Access Control List for kerberos server
cp /tmp/kadm5.acl /etc/krb5kdc/kadm5.acl

# Add LDAP users to kerberos
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/user_to_kerberos.ldif


## ADD PRINCIPALS ##

# Start admin server
service krb5-admin-server start

# Add existing test user as principal
kadmin.local -q "add_principal -x dn=uid=$KRB_LDAP_TESTUSER_UID,ou=People,$KRB_LDAP_DN -pw $KRB_LDAP_TESTUSER_PASS $KRB_LDAP_TESTUSER_UID"

# Get container ID of SSSD Client
while ! (test -f '/container_ids/sssd-client.txt'); do sleep 5; done
sssd_id=$(</container_ids/sssd-client.txt)
# Add SSSD Client as principal, and create keytab
kadmin.local -q "add_principal -randkey sssd/$sssd_id@$KRB_REALM"
kadmin.local -q "ktadd -k /etc/krb5.keytab sssd/$sssd_id@$KRB_REALM"
cp /etc/krb5.keytab /tmp/shared2/service-sssd.keytab
chmod a+rwx /etc/krb5.keytab # don't know which permissions are necessary, so set all permissions for everyone. (This is not a good solution)

# Get container ID of LDAP Service
while ! (test -f '/container_ids/service-ldap.txt'); do sleep 5; done
ldap_id=$(</container_ids/service-ldap.txt)
# Add OpenLDAP as principal, and create keytab. Using aliases
kadmin.local -q "add_principal -randkey ldap/openldap-service.thesis_lan_net@$KRB_REALM"
kadmin.local -q "ktadd -k /etc/service-ldap.keytab ldap/openldap-service.thesis_lan_net@$KRB_REALM"
kadmin.local -q "add_principal -randkey ldap/$ldap_id@$KRB_REALM"
kadmin.local -q "ktadd -k /etc/service-ldap.keytab ldap/$ldap_id@$KRB_REALM"

cp /etc/service-ldap.keytab /tmp/shared/service-ldap.keytab


# kadmin.local -q "add_principal -randkey ldap/$ldap_id@$KRB_REALM"
# kadmin.local -q "ktadd -k /etc/service-ldap2.keytab ldap/$ldap_id@$KRB_REALM"
# cp /etc/service-ldap2.keytab /tmp/shared/service-ldap2.keytab
chmod a+rwx /etc/service-ldap.keytab # don't know which permissions are necessary, so set all permissions for everyone. (This is not a good solution)

echo "List principals"
kadmin.local -q listprincs

service krb5-admin-server stop
service slapd stop

echo "END KERBEROS SETUP"