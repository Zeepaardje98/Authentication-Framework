#!/bin/bash

cat > /tmp/update_ACLs.ldif <<EOF
dn: olcDatabase={1}mdb,cn=config
add: olcAccess
olcAccess: {2}to attrs=krbPrincipalKey
    by anonymous auth
    by dn.exact="uid=kdc-service,$KRB_LDAP_DN" read
    by dn.exact="uid=kadmin-service,$KRB_LDAP_DN" write
    by self write
    by * none
-
add: olcAccess
olcAccess: {3}to dn.subtree="cn=krbContainer,$KRB_LDAP_DN"
    by dn.exact="uid=kdc-service,$KRB_LDAP_DN" read
    by dn.exact="uid=kadmin-service,$KRB_LDAP_DN" write
    by * none
EOF