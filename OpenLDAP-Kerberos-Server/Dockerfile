# Use Ubuntu as the base image
FROM ubuntu:24.04

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    slapd \
    ldap-utils \
    krb5-kdc-ldap \
    krb5-admin-server \
    schema2ldif \
    # For network testing commands
    net-tools \
    iputils-ping \
    dnsutils\
    # Stream editor, used for fixing 'service slapd stop' bug in docker
    sed

# BugFix: 'service slapd stop' not working in docker
RUN sed -i 's/--exec $SLAPD 2/--name slapd 2/' /etc/init.d/slapd

# Add files needed for SSSD and Kerberos setup. These files are produced by a startup script to allow
# for injecting environment variables into these files.
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY setup/*.sh tmp/setup/
# These files dont need injected variables
COPY setup/*.ldif tmp/


# Get kerberos schema for openldap
COPY schema/kerberos.schema.gz /etc/ldap/schema/kerberos.schema.gz
RUN gunzip /etc/ldap/schema/kerberos.schema.gz

# Add setup and entrypoint scripts
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY /*.sh /tmp/

# Expose Kerberos ports
EXPOSE 88 749 389 636

CMD /tmp/entrypoint.sh