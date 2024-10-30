#!/bin/bash

cat > /tmp/map_gssapi_users.ldif <<EOF
dn: cn=config
changetype: modify
add: olcAuthzRegexp
olcAuthzRegexp: "uid=([^,]*),cn=example,cn=gssapi,cn=auth" "uid=\$1,ou=People,dc=local"
EOF