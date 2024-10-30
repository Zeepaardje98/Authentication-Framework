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
    $LDAP_SERVICE_HOST = $KRB_REALM
    $SSSD_CLIENT_HOST = $KRB_REALM
    $KERBEROS_HOST = $KRB_REALM
    .$ON_PREMISES_NETWORK = $KRB_REALM
    $ON_PREMISES_NETWORK = $KRB_REALM
EOF