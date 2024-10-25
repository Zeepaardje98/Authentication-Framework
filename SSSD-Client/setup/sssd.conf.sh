#!/bin/bash

cat > /etc/sssd/sssd.conf <<EOF
[sssd]
    config_file_version = 2
    domains = $KRB_REALM

[domain/$KRB_REALM]
    id_provider = ldap
    ldap_uri = ldap://kerberos
    ldap_search_base = $KRB_LDAP_DN
    auth_provider = krb5

    krb5_kdc = $KRB_KDC_IP
    krb5_realm = $KRB_REALM
    cache_credentials = True
    krb5_validate = True
EOF