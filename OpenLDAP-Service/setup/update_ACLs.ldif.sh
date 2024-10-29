#!/bin/bash

cat > /tmp/update_ACLs.ldif <<EOF
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to dn.subtree="dc=local"
  by group.exact="cn=developers,ou=Groups,$LDAP_DN" write
  by group.exact="cn=gssapiGroup,ou=Groups,$LDAP_DN" read
  by * read
  by anonymous auth
EOF

# olcAccess: to * by * manage
# by dn.exact="uid=john,cn=example,cn=gssapi,cn=auth" read