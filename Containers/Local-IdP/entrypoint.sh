#!/bin/bash
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"

echo "CONTAINER STARTED"

if [ ! -f /$CONTAINER_FIRST_STARTUP ]; then
    touch /$CONTAINER_FIRST_STARTUP

    # Generate all files needed for setup, using environment variables.
    for f in /tmp/setup/*.sh; do
        bash "$f"
        rm "$f"
    done

    # Setup
    /tmp/setup_openldap.sh
    /tmp/setup_kerberos.sh
fi

service slapd start
krb5kdc -n
# service krb5-kdc start
service krb5-admin-server start

while sleep 3600; do echo "CONTAINER RUNNING"; done
