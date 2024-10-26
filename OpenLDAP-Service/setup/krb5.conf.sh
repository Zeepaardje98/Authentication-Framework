#!/bin/bash

cat > /etc/krb5.conf <<EOF
[libdefaults]
    default_realm = $KRB_REALM

[realms]
    $KRB_REALM = {
        kdc = $KERBEROS_HOST
        admin_server = $KERBEROS_HOST
    }

[domain_realm]
    .$KRB_LDAP_DOMAIN = $KRB_REALM
    $KRB_LDAP_DOMAIN = $KRB_REALM
    .thesis_lan_net = $KRB_REALM
    thesis_lan_net = $KRB_REALM
EOF