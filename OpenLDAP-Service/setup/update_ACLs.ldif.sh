#!/bin/bash

# cat > /tmp/update_ACLs.ldif <<EOF
# dn: olcDatabase={1}mdb,cn=config
# changetype: modify
# replace: olcAccess
# olcAccess: to *
#   by group.exact="cn=developers,ou=groups,$LDAP_DN" write
#   by users read
#   by anonymous auth
# EOF



cat > /tmp/update_ACLs.ldif <<EOF
access to *
    by gssapi="ldap/openldap-service.thesis_lan_net@$KRB_REALM" read
    by * read
EOF