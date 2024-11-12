#!/bin/bash
server_id="$1"

cat > /tmp/setup/set_serverId.ldif <<EOF
dn: cn=config
changetype: modify
add: olcServerID
olcServerID: $server_id
EOF