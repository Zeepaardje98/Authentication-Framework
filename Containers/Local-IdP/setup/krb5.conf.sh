#!/bin/bash

cat > /tmp/krb5.conf <<EOF
[libdefaults]
    default_realm = $KRB_REALM

    # The following krb5.conf variables are only for MIT Kerberos.
    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true

    # The following encryption type specification will be used by MIT Kerberos
    # if uncommented.  In general, the defaults in the MIT Kerberos code are
    # correct and overriding these specifications only serves to disable new
    # encryption types as they are added, creating interoperability problems.
    #
    # The only time when you might need to uncomment these lines and change
    # the enctypes is if you have local software that will break on ticket
    # caches containing ticket encryption types it doesn't know about (such as
    # old versions of Sun Java).

    #     default_tgs_enctypes = des3-hmac-sha1
    #     default_tkt_enctypes = des3-hmac-sha1
    #     permitted_enctypes = des3-hmac-sha1

    # The following libdefaults parameters are only for Heimdal Kerberos.
    fcc-mit-ticketflags = true

[realms]
    $KRB_REALM = {
        kdc = kdc01.$KRB_LDAP_DOMAIN
        kdc = kdc02.$KRB_LDAP_DOMAIN
        admin_server = kdc01.$KRB_LDAP_DOMAIN
        default_domain = $KRB_LDAP_DOMAIN
        database_module = openldap_ldapconf
    }

[dbdefaults]
    ldap_kerberos_container_dn = cn=krbContainer,$KRB_LDAP_DN

[dbmodules]
    openldap_ldapconf = {
        db_library = kldap

		# if either of these is false, then the ldap_kdc_dn needs to
		# have write access
		disable_last_success = true
		disable_lockout  = true

        # this object needs to have read rights on
        # the realm container, principal container and realm sub-trees
        ldap_kdc_dn = "uid=kdc-service,$KRB_LDAP_DN"

        # this object needs to have read and write rights on
        # the realm container, principal container and realm sub-trees
        ldap_kadmind_dn = "uid=kadmin-service,$KRB_LDAP_DN"

        ldap_service_password_file = /etc/krb5kdc/service.keyfile
        ldap_servers = ldapi:///
        ldap_conns_per_server = 5
    }

[domain_realm]
    $LDAP_SERVICE_HOST = $KRB_REALM
    $SSSD_CLIENT_HOST = $KRB_REALM
    $KERBEROS_HOST = $KRB_REALM
    .$ON_PREMISES_NETWORK = $KRB_REALM
    $ON_PREMISES_NETWORK = $KRB_REALM

[logging]
    default = STDERR
    kdc = STDERR
    admin_server = STDERR
EOF