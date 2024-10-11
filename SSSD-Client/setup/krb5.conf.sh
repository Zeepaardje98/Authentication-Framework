#!/bin/bash

cat > /etc/krb5.conf <<EOF
[libdefaults]
    default_realm = $KRB_REALM
    dns_lookup_realm = false
    dns_lookup_kdc = false

[realms]
    $KRB_REALM = {
        kdc = $KRB_KDC_IP
        admin_server = $KRB_KDC_IP
    }

[domain_realm]
    .$KRB_LDAP_DOMAIN = $KRB_REALM
    $KRB_LDAP_DOMAIN = $KRB_REALM
EOF