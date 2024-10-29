#!/bin/bash

cat > /etc/krb5.conf <<EOF
[libdefaults]
    default_realm = $KRB_REALM
    # dns_lookup_realm = true
    # dns_lookup_kdc = true
    rdns = false
    canonicalize = false
    qualify_shortname = ""

[realms]
    $KRB_REALM = {
        kdc = $KERBEROS_HOST
        admin_server = $KERBEROS_HOST
    }

[domain_realm]
    .$KRB_LDAP_DOMAIN = $KRB_REALM
    $KRB_LDAP_DOMAIN = $KRB_REALM
    .lan_net = EXAMPLE
    lan_net = EXAMPLE
EOF