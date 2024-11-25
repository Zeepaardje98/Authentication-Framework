# Use base image
FROM base-openldap

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    libsasl2-modules-gssapi-mit \
    krb5-user

# Expose default LDAP ports
EXPOSE 389 636

