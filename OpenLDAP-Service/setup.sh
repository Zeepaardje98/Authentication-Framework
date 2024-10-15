#!/bin/bash
echo "TEST OPENLDAP RUNNING"
# ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config dn # Check
ldapsearch -x -H ldap://openldap:389 -D "cn=admin,dc=external,dc=com" -w adminpassword -b "dc=external,dc=com"


# ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/configure_sasl.ldif

# ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/update_ACLs.ldif