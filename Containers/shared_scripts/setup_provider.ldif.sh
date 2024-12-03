#!/bin/bash

cat > /tmp/setup/setup_provider.ldif <<EOF
# Set up syncrepl as a provider
dn: cn=module,cn=config
changetype: add
objectClass: olcModuleList
cn: module
olcModulePath: /usr/lib/ldap
olcModuleLoad: syncprov.so
EOF