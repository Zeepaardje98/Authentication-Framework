#!/bin/bash

cat > /etc/sssd/sssd.conf <<EOF
[sssd]
    config_file_version = 2
    services = nss, pam
    domains = $KRB_REALM

[domain/$KRB_REALM]
    id_provider = ldap
    auth_provider = krb5
    chpass_provider = krb5

    krb5_server = $KRB_KDC_IP
    krb5_kpasswd = $KRB_KDC_IP
    krb5_realm = $KRB_REALM

    ldap_uri = ldap://$KRB_KDC_IP
    ldap_search_base = $KRB_LDAP_DN

    cache_credentials = true
    enumerate = true
EOF