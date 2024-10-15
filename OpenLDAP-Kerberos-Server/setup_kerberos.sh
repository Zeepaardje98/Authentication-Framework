#!/bin/bash

# Start OpenLDAP in the background
echo "Set up Kerberos"

ldap-schema-manager -i kerberos.schema

echo "Add index"
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/krbPrincipalName_index.ldif

echo "Add kerberos entities"
echo "cn=admin,$KRB_LDAP_DN"
ldapadd -w "$KRB_LDAP_PASSWORD" -x -D "cn=admin,$KRB_LDAP_DN" -f /tmp/add_kerberos_entities.ldif

echo "Change passwords of entities"
ldappasswd -w "$KRB_LDAP_PASSWORD" -x -D "cn=admin,$KRB_LDAP_DN" "uid=kdc-service,$KRB_LDAP_DN" -s "$KRB_KDC_PASSWORD"
ldappasswd -w "$KRB_LDAP_PASSWORD" -x -D "cn=admin,$KRB_LDAP_DN" "uid=kadmin-service,$KRB_LDAP_DN" -s "$KRB_ADMIN_PASSWORD"

# Test kdc service and admin users
echo "Test kerberos entities"
ldapwhoami -w "$KRB_KDC_PASSWORD" -x -D "uid=kdc-service,$KRB_LDAP_DN"
ldapwhoami -w "$KRB_ADMIN_PASSWORD" -x -D "uid=kadmin-service,$KRB_LDAP_DN"

# Update ACLs
echo "Update ACLs"
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/update_ACLs.ldif

echo "Replace configuration"
cp /tmp/krb5.conf /etc/krb5.conf

echo "Create the kerberos realm"
kdb5_ldap_util -D "cn=admin,$KRB_LDAP_DN" -w "$KRB_LDAP_PASSWORD" -H ldapi:/// create -P "$DB_PASS" -subtrees "$KRB_LDAP_DN" -s -r "$KRB_REALM"

echo "Create stashes"
yes $KRB_KDC_PASSWORD | kdb5_ldap_util -D "cn=admin,$KRB_LDAP_DN" -w "$KRB_LDAP_PASSWORD" -H ldapi:/// stashsrvpw -f /etc/krb5kdc/service.keyfile "uid=kdc-service,$KRB_LDAP_DN"
yes $KRB_ADMIN_PASSWORD | kdb5_ldap_util -D "cn=admin,$KRB_LDAP_DN" -w "$KRB_LDAP_PASSWORD" -H ldapi:/// stashsrvpw -f /etc/krb5kdc/service.keyfile "uid=kadmin-service,$KRB_LDAP_DN"

echo "Create acl file for admin server"
cp /tmp/kadm5.acl /etc/krb5kdc/kadm5.acl

echo "Start kdc and admin server"
service krb5-kdc start
service krb5-admin-server start

ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /tmp/user_to_kerberos.ldif
kadmin.local -q "add_principal -x dn=uid=$KRB_LDAP_TESTUSER_UID,ou=People,$KRB_LDAP_DN -pw $KRB_LDAP_TESTUSER_PASS $KRB_LDAP_TESTUSER_UID"

# Add Service
# kadmin.local -q "add_principal -randkey ldap/openldap@$KRB_REALM"
# kadmin.local -q "ktadd -k /etc/ldap/kerberos/ldap.keytab ldap/openldap@$KRB_REALM"

# Clean up files
rm /tmp/krbPrincipalName_index.ldif


echo "END KERBEROS SETUP"