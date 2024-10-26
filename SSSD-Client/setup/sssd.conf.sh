#!/bin/bash

# Get container ID of Identity Provider (Kerberos with OpenLDAP back-end)
while ! (test -f '/container_ids/identity-provider.txt'); do sleep 5; done
idp_id=$(</container_ids/identity-provider.txt)

cat > /etc/sssd/sssd.conf <<EOF
[sssd]
    config_file_version = 2
    domains = $KRB_REALM

[domain/$KRB_REALM]
    id_provider = ldap
    ldap_uri = ldap://$idp_id
    ldap_search_base = $KRB_LDAP_DN
    auth_provider = krb5

    krb5_kdc = $idp_id
    krb5_realm = $KRB_REALM
    cache_credentials = true
    krb5_validate = true
EOF