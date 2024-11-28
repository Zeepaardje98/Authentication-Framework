#!/bin/bash

# Define the new SLAPD_SERVICES value
NEW_SERVICES="ldap:/// ldapi:///"
for url in "$@"; do
    NEW_SERVICES="$NEW_SERVICES ldap://$url"
done

CONFIG_FILE=/etc/default/slapd

# Check if SLAPD_SERVICES is already defined in the file
if grep -q "^SLAPD_SERVICES=" "$CONFIG_FILE"; then
    # Replace the existing SLAPD_SERVICES value
    sed -i "s|^SLAPD_SERVICES=.*|SLAPD_SERVICES=\"${NEW_SERVICES}\"|" "$CONFIG_FILE"
else
    # Add SLAPD_SERVICES if it doesn't exist
    echo -e "\nSLAPD_SERVICES=\"${NEW_SERVICES}\"" >> "$CONFIG_FILE"
fi