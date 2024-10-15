#!/bin/bash

cat > /tmp/configure_sasl.ldif <<EOF
dn: cn=config
changetype: modify
replace: olcSaslRealm
olcSaslRealm: $KRB_REALM

replace: olcSaslSecProps
olcSaslSecProps: none
EOF