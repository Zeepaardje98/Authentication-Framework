#!/bin/bash

filepath="/tmp/setup/add_data_replication.ldif"
BACKEND=mdb


[ "$#" -eq 0 ] && exit 0
rootpassword=$1
shift

[ "$#" -eq 0 ] && exit 0
basedn=$1
shift

# No servers domains provided
[ "$#" -eq 0 ] && exit 0


# add: objectClass
# objectClass: olcDatabaseConfig
# objectClass: olc${BACKEND}Config

# add: olcDatabase
# olcDatabase: {1}$BACKEND

# add: olcSuffix
# olcSuffix: $basedn

# add: olcDbDirectory
# olcDbDirectory: ./db

cat > $filepath <<EOF
dn: olcDatabase={1}$BACKEND,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $rootpassword
-
add: olcLimits
olcLimits: dn.exact="cn=admin,$basedn" time.soft=unlimited time.hard=unlimited size.soft=unlimited size.hard=unlimited
-
add: olcSyncRepl
EOF

c=1
for serverDomain in "$@"; do
    id=$(($#+c))
    rid=$(printf "%03d\n" "$id")
    echo "olcSyncRepl: rid=$rid provider=\"ldap://$serverDomain\" binddn=\"cn=admin,$basedn\" bindmethod=simple credentials=$rootpassword \
searchbase=\"$basedn\" type=refreshOnly interval=00:00:00:10 retry=\"5 5 300 5\" timeout=1" >> $filepath
    ((c++))
done

cat >> $filepath <<EOF
-
add: olcMultiProvider
olcMultiProvider: TRUE

dn: olcOverlay=syncprov,olcDatabase={1}${BACKEND},cn=config
changetype: add
objectClass: olcOverlayConfig
objectClass: olcSyncProvConfig
olcOverlay: syncprov
EOF

# olcSyncRepl: rid=004 provider=$URI1 binddn=\"cn=admin,cn=config\" bindmethod=simple credentials=$PASSWD searchbase="$BASEDN" type=refreshOnly interval=00:00:00:10 retry="5 5 300 5" timeout=1
# olcSyncRepl: rid=005 provider=$URI2 binddn=\"cn=admin,cn=config\" bindmethod=simple credentials=$PASSWD searchbase="$BASEDN" type=refreshOnly interval=00:00:00:10 retry="5 5 300 5" timeout=1
# olcSyncRepl: rid=006 provider=$URI3 binddn=\"cn=admin,cn=config\" bindmethod=simple credentials=$PASSWD searchbase="$BASEDN" type=refreshOnly interval=00:00:00:10 retry="5 5 300 5" timeout=1
# olcMultiProvider: TRUE