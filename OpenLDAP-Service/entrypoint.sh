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
slapd -d 384

while sleep 3600; do echo "CONTAINER RUNNING"; done