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
    krb5-kdc-ldap \
    krb5-admin-server \
    schema2ldif \
    # For network testing commands
    net-tools

# Arguments needed during buildtime
ARG KRB_LDAP_DOMAIN
ARG KRB_LDAP_DN
ARG KRB_LDAP_TESTUSER_PASS
ARG KRB_LDAP_TESTUSER_UID
ARG KRB_REALM

# Add files needed for LDAP and Kerberos setup. These files are produced by scripts to allow
# for injecting the previously defined arguments.
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY setup/*.sh tmp/setup/
RUN for script in /tmp/setup/*.sh; do \
        echo "Running $script"; \
        /bin/bash "$script"; \
    done
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
EXPOSE 88 749

CMD /tmp/entrypoint.sh