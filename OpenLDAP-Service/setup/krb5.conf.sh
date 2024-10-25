#!/bin/bash

# Get container ID of Identity Provider (Kerberos with OpenLDAP back-end)
while ! (test -f '/container_ids/identity-provider.txt'); do sleep 5; done
idp_id=$(</container_ids/identity-provider.txt)

cat > /etc/krb5.conf <<EOF
[libdefaults]
    default_realm = $KRB_REALM
    dns_lookup_realm = false
    dns_lookup_kdc = false

[realms]
    $KRB_REALM = {
        kdc = $idp_id
        admin_server = $idp_id
    }

[domain_realm]
    .$KRB_LDAP_DOMAIN = $KRB_REALM
    $KRB_LDAP_DOMAIN = $KRB_REALM
    .thesis_lan_net = $KRB_REALM
    thesis_lan_net = $KRB_REALM
EOF