#!/bin/bash

cat > /tmp/map_gssapi_users.ldif <<EOF
dn: cn=config
changetype: modify
add: olcAuthzRegexp
olcAuthzRegexp: "uid=([^,]*),cn=$KRB_REALM,cn=gssapi,cn=auth" "uid=\$1,ou=People,$LDAP_DN"
EOF