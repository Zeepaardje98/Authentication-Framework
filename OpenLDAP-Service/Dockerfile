# Use Ubuntu as the base image
FROM ubuntu:20.04
RUN printenv

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    slapd \
    ldap-utils \
    # SASL Tools
    libsasl2-modules-gssapi-mit \
    krb5-user \
    # For network testing commands
    iputils-ping \
    netcat-openbsd \
    # Stream editor, used for fixing 'service slapd stop' bug in docker
    sed

# Fix 'service slapd stop' bug in docker
RUN sed -i 's/--exec $SLAPD 2/--name slapd 2/' /etc/init.d/slapd

# Add files needed for LDAP and Kerberos setup. These files are produced by scripts to allow
# for injecting the previously defined arguments.
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY setup/*.sh tmp/setup/
# These files dont need injected variables
COPY setup/logging.ldif tmp/logging.ldif
COPY setup/log-slapd.conf etc/rsyslog.d/log-slapd.conf


# Add setup scripts
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY /*.sh /tmp/

# Expose default LDAP ports
EXPOSE 389 636

CMD /tmp/entrypoint.sh
