#!/bin/bash

cat > /tmp/setup/user_to_kerberos.ldif <<EOF
dn: olcDatabase={1}mdb,cn=config
add: olcAccess
olcAccess: {4}to dn.subtree="ou=People,$KRB_LDAP_DN"
    by dn.exact="uid=kdc-service,$KRB_LDAP_DN" read
    by dn.exact="uid=kadmin-service,$KRB_LDAP_DN" write
    by * break
EOF