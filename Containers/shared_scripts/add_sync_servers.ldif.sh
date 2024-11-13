#!/bin/bash
# Requires the first argument to be the root password of to-be synced servers. All later arguments
# are domains of the to-be synced servers, in order of their ID.

if ["$#" -eq 0]; then
    # No servers domains provided
    exit 0
fi

filepath="/tmp/setup/add_sync_servers.ldif"
rootpassword=$1
shift

cat > $filepath <<EOF
# Set up provider node
dn: cn=config
changetype: modify
replace: olcServerID
EOF

c=1
for serverDomain in "$@"; do
    echo "olcServerID: $c ldap://$serverDomain" >> $filepath
    ((c++))
done
# olcServerID: 1 $KERBEROS_HOST.$ON_PREMISES_NETWORK
# olcServerID: 2 $CLOUD_IDP_HOST.$CLOUD_IDP_NETWORK
# olcServerID: 3 $LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK

cat >> $filepath <<EOF

dn: olcOverlay=syncprov,olcDatabase={0}config,cn=config
changetype: add
objectClass: olcOverlayConfig
objectClass: olcSyncProvConfig
olcOverlay: syncprov

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcSyncRepl
EOF

c=1
for serverDomain in "$@"; do
    echo "olcSyncRepl: rid=00$c provider=\"ldap://$serverDomain\" binddn=\"cn=config\" bindmethod=simple \
credentials=$rootpassword searchbase=\"cn=config\" type=refreshAndPersist retry=\"5 5 300 5\" timeout=1" \
    >> $filepath
    ((c++))
done
# olcSyncRepl: rid=001 provider=$KERBEROS_HOST.$ON_PREMISES_NETWORK binddn="cn=config" bindmethod=simple
#     credentials=secret searchbase="cn=config" type=refreshAndPersist retry="5 5 300 5" timeout=1
# olcSyncRepl: rid=002 provider=$CLOUD_IDP_HOST.$CLOUD_IDP_NETWORK binddn="cn=config" bindmethod=simple
#     credentials=secret searchbase="cn=config" type=refreshAndPersist retry="5 5 300 5" timeout=1
# olcSyncRepl: rid=003 provider=$LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK binddn="cn=config" bindmethod=simple
#     credentials=secret searchbase="cn=config" type=refreshAndPersist retry="5 5 300 5" timeout=1

cat >> $filepath <<EOF
-
add: olcMultiProvider
olcMultiProvider: TRUE
EOF