#!/bin/bash

cat > /tmp/configure_sasl.ldif <<EOF
dn: cn=config
changetype: modify
replace: olcSaslRealm
olcSaslRealm: $KRB_REALM

# replace: olcSaslSecProps
# olcSaslSecProps: none

dn: cn=config
changetype: modify
replace: olcSaslHost
olcSaslHost: $LDAP_SERVICE_HOST.$ON_PREMISES_NETWORK

EOF