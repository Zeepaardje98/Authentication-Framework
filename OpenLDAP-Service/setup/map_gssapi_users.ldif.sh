#!/bin/bash

cat > /tmp/map_gssapi_users.ldif <<EOF
dn: cn=config
changetype: modify
add: olcAuthzRegexp
olcAuthzRegexp: "uid=([^,]*),cn=example,cn=gssapi,cn=auth" " ldap:///ou=People,dc=local??one?(uid=$1)"
EOF