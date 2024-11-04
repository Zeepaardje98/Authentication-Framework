#!/bin/bash

cat > /tmp/setup_provider.ldif <<EOF
# Set up syncrepl as a provider
dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
olcModulePath: /usr/local/libexec/openldap
olcModuleLoad: syncprov.la

# Set up provider node
dn: cn=config
changetype: modify
replace: olcServerID
olcServerID: 1 $KERBEROS_HOST.$ON_PREMISES_NETWORK
olcServerID: 2 $CLOUD_IDP_HOST.$CLOUD_IDP_NETWORK
olcServerID: 3 $LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK

dn: olcOverlay=syncprov,olcDatabase={0}config,cn=config
changetype: add
objectClass: olcOverlayConfig
olcOverlay: syncprov

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcSyncRepl
olcSyncRepl: rid=001 provider=$KERBEROS_HOST.$ON_PREMISES_NETWORK binddn="cn=config" bindmethod=simple
    credentials=secret searchbase="cn=config" type=refreshAndPersist retry="5 5 300 5" timeout=1
olcSyncRepl: rid=002 provider=$CLOUD_IDP_HOST.$CLOUD_IDP_NETWORK binddn="cn=config" bindmethod=simple
    credentials=secret searchbase="cn=config" type=refreshAndPersist retry="5 5 300 5" timeout=1
olcSyncRepl: rid=003 provider=$LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK binddn="cn=config" bindmethod=simple
    credentials=secret searchbase="cn=config" type=refreshAndPersist retry="5 5 300 5" timeout=1
-
add: olcMultiProvider
olcMultiProvider: TRUE
EOF