# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    sssd-ldap \
    sssd-krb5 \
    ldap-utils \
    krb5-user \
    # For network testing commands
    iputils-ping \
    netcat-openbsd

ARG KRB_LDAP_DOMAIN
ARG KRB_LDAP_DN
ARG KRB_REALM
ARG KRB_KDC_IP

# Add files needed for SSSD and Kerberos setup. These files are produced by scripts to allow
# for injecting variables.
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY setup/*.sh tmp/setup/
RUN for script in /tmp/setup/*.sh; do \
        echo "Running $script"; \
        /bin/bash "$script"; \
    done
# These files dont need injected variables


# Add setup scripts
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY /*.sh /tmp/

CMD /tmp/entrypoint.sh
