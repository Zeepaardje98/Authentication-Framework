# Use Ubuntu as the base image
# FROM ubuntu:24.04

# Use Ubuntu as the base image
FROM base-openldap-sync

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    krb5-kdc-ldap \
    krb5-admin-server \
    schema2ldif

# Get kerberos schema for openldap
ADD ${BASEFOLDER}/schema/kerberos.schema.gz /etc/ldap/schema/kerberos.schema.gz
RUN gunzip /etc/ldap/schema/kerberos.schema.gz

# Expose Kerberos ports
EXPOSE 88 749 389 636