# Use Ubuntu as the base image
FROM ubuntu:24.04

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install ldap packages
RUN apt-get update && \
    apt-get install -y \
    slapd \
    ldap-utils \
    # For network testing commands
    iputils-ping \
    netcat-openbsd \
    dnsutils

# Base folder of the docker image. All files outside of Containers/${FOLDER} or
# Containers/shared_scripts get ignored by .dockerignore
ONBUILD ARG BASEFOLDER

ONBUILD RUN ls

# Add files needed for SSSD and Kerberos setup. These files are produced by a startup script to allow
# for injecting environment variables into these files.
# ONBUILD ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
ONBUILD COPY ./${BASEFOLDER}/setup/ tmp/setup/

# Add setup and entrypoint scripts
# ONBUILD ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
ONBUILD COPY ./${BASEFOLDER}/*.sh /tmp/

# LDAP setting args:
ONBUILD ARG ADMINPASSWORD
ONBUILD ARG ROOTPASSWORD
ONBUILD ARG DOMAIN
ONBUILD ARG ORGANISATION

ONBUILD RUN echo "${ADMINPASSWORD} ${ROOTPASSWORD} ${DOMAIN} ${ORGANISATION}"

# Configure debconf selections for slapd
ONBUILD RUN echo "slapd slapd/internal/generated_adminpw password ${ADMINPASSWORD}" | debconf-set-selections && \
    echo "slapd slapd/internal/adminpw password ${ADMINPASSWORD}" | debconf-set-selections && \
    echo "slapd slapd/password2 password ${ROOTPASSWORD}" | debconf-set-selections && \
    echo "slapd slapd/password1 password ${ROOTPASSWORD}" | debconf-set-selections && \
    echo "slapd slapd/domain string ${DOMAIN}" | debconf-set-selections && \
    echo "slapd shared/organization string ${ORGANISATION}" | debconf-set-selections && \
    echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
    echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
    echo "slapd slapd/dump_database select when needed" | debconf-set-selections && \
    echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections
    
# Reconfigure slapd to apply the configuration
ONBUILD RUN dpkg-reconfigure -f noninteractive slapd

CMD /tmp/entrypoint.sh