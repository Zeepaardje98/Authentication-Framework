#!/bin/bash

cat > /etc/sssd/sssd.conf <<EOF
[sssd]
    config_file_version = 2
    domains = $KRB_REALM

[domain/$KRB_REALM]
    id_provider = ldap
    ldap_uri = ldap://$KERBEROS_HOST
    ldap_search_base = $KRB_LDAP_DN
    auth_provider = krb5

    krb5_kdc = $KERBEROS_HOST
    krb5_realm = $KRB_REALM
    cache_credentials = true
    krb5_validate = true
EOF