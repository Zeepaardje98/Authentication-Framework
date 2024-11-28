#!/bin/bash
server_id="$1"

cat > /tmp/setup/set_serverId.ldif <<EOF
dn: cn=config
changetype: modify
replace: olcServerID
olcServerID: $server_id
-

dn: olcDatabase={0}config,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: secret
EOF

# olcRootPW = secret