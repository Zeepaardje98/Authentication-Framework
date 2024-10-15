#!/bin/bash

cat > /tmp/update_ACLs.ldif <<EOF
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to *
  by group.exact="cn=developers,ou=groups,dc=example,dc=com" write
  by users read
  by anonymous auth
EOF