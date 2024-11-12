#!/bin/bash

cat > /tmp/setup/setup_provider.ldif <<EOF
dn: cn=module,cn=config
changetype: add
objectClass: olcModuleList
cn: module
olcModulePath: /usr/lib/ldap
olcModuleLoad: syncprov.la
EOF