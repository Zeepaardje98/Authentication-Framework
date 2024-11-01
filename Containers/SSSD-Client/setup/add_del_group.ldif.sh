#!/bin/bash

cat > /tmp/add_group.ldif <<EOF
dn: cn=testGroup,ou=Groups,$LDAP_DN
objectClass: posixGroup
cn: testGroup
gidNumber:6969
EOF

cat > /tmp/del_group.ldif <<EOF
dn: cn=testGroup,ou=Groups,$LDAP_DN
changetype: delete
EOF