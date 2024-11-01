#!/bin/bash

# First startup, set up necessary files
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
if [ ! -f /$CONTAINER_FIRST_STARTUP ]; then
    touch /$CONTAINER_FIRST_STARTUP

    # Generate all files needed for setup, using environment variables.
    for f in /tmp/setup/*.sh; do bash "$f" && rm "$f"; done
    
    # Run setup
    /tmp/setup.sh
fi

# Run OpenLDAP Server

# service slapd start
# pkill rsyslogd
# ps aux | grep rsyslog
# echo "-----"
# rsyslogd
# ps aux | grep rsyslog
# ps aux | grep syslogd
# echo "-----"
# pkill slapd
# ps aux | grep slapd
# echo "-----"
slapd -h "ldap:/// ldapi:///" -d 960
# ps aux | grep slapd
# Log level check
ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=config olcLogLevel



while sleep 3600; do echo "CONTAINER RUNNING"; done