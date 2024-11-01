# Use base image
FROM base-openldap-img

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    libsasl2-modules-gssapi-mit \
    krb5-user

# Add files needed for SSSD and Kerberos setup. These files are produced by a startup script to allow
# for injecting environment variables into these files.
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY setup/*.sh tmp/setup/
# These files dont need injected variables
COPY setup/*.ldif tmp/

# Add setup and entrypoint scripts
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY /*.sh /tmp/

# Expose default LDAP ports
EXPOSE 389 636

CMD /tmp/entrypoint.sh
