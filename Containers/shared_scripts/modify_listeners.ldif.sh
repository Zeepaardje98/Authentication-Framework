#!/bin/bash

filepath="/tmp/setup/modify_listeners.ldif"

cat > $filepath <<EOF
dn: cn=config
changetype: modify
replace: olcListen
EOF

for url in "$@"; do
    echo "olcListen: ldap://$url" >> $filepath
done
echo "olcListen: ldapi:///" >> $filepath

