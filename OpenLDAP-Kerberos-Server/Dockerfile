# Use Ubuntu as the base image
FROM ubuntu:20.04

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
    # Stream editor, used for fixing 'service slapd stop' bug in docker
    sed

# Fix 'service slapd stop' bug in docker
RUN sed -i 's/--exec $SLAPD 2/--name slapd 2/' /etc/init.d/slapd

# Add files needed for LDAP and Kerberos setup. These files are produced by scripts to allow
# for injecting the previously defined arguments.
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY setup/*.sh tmp/setup/
# These files dont need injected variables
COPY setup/krbPrincipalName_index.ldif tmp/krbPrincipalName_index.ldif
COPY setup/logging.ldif tmp/logging.ldif
COPY setup/uid_index.ldif tmp/uid_index.ldif



# Get kerberos schema
COPY schema/kerberos.schema.gz /etc/ldap/schema/kerberos.schema.gz
RUN gunzip /etc/ldap/schema/kerberos.schema.gz

# Add setup scripts
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY /*.sh /tmp/

# Expose Kerberos ports
EXPOSE 88 749 389 636

CMD /tmp/entrypoint.sh