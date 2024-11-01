#!/bin/bash

cat > /tmp/configure_sasl.ldif <<EOF
dn: cn=config
changetype: modify
replace: olcSaslRealm
olcSaslRealm: $KRB_REALM

dn: cn=config
changetype: modify
replace: olcSaslHost
olcSaslHost: $LDAP_SERVICE_HOST


EOF