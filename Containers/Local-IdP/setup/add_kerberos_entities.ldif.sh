#!/bin/bash

cat > /tmp/setup/add_kerberos_entities.ldif <<EOF
dn: uid=kdc-service,$KRB_LDAP_DN
uid: kdc-service
objectClass: account
objectClass: simpleSecurityObject
userPassword: {CRYPT}x
description: Account used for the Kerberos KDC

dn: uid=kadmin-service,$KRB_LDAP_DN
uid: kadmin-service
objectClass: account
objectClass: simpleSecurityObject
userPassword: {CRYPT}x
description: Account used for the Kerberos Admin server
EOF