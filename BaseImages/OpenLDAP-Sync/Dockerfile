# Use Ubuntu as the base image
FROM ubuntu:24.04

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install ldap packages
RUN apt-get update && \
    apt-get install -y \
    slapd \
    ldap-utils \
    # Fix slapd not stopping on service slapd stop
    sed \
    # For network testing commands
    iputils-ping \
    netcat-openbsd \
    dnsutils

RUN sed -i 's/--exec $SLAPD 2/--name slapd 2/' /etc/init.d/slapd


# Base folder of the docker image. All files outside of Containers/${FOLDER} or
# Containers/shared_scripts get ignored by .dockerignore
ONBUILD ARG BASEFOLDER

# Add files needed for SSSD and Kerberos setup. These files are produced by a startup script to allow
# for injecting environment variables into these files.
ONBUILD COPY ./${BASEFOLDER}/setup/ tmp/setup/

# Add setup and entrypoint scripts
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

# Create ldif for correct listeners (SLAPD_SERVICES in /etc/default/slapd)
ONBUILD ARG URLS
ONBUILD COPY /shared_scripts/modify_listeners.ldif.sh /tmp/setup
ONBUILD COPY /shared_scripts/modify_listeners.sh /tmp/setup
ONBUILD RUN /tmp/setup/modify_listeners.ldif.sh ${URLS}
# ONBUILD RUN /tmp/setup/modify_listeners.sh ${URLS}
ONBUILD RUN rm /tmp/setup/modify_listeners.ldif.sh
# ONBUILD RUN rm /tmp/setup/modify_listeners.sh
# Apply listener settings
ONBUILD USER openldap
# ONBUILD RUN slapmodify -b cn=config -l /tmp/setup/modify_listeners.ldif
ONBUILD USER root

# Create ldif file for server Id (needed for synchronisation)
ONBUILD ARG SERVER_ID
ONBUILD COPY /shared_scripts/set_serverId.ldif.sh /tmp/setup
ONBUILD RUN /tmp/setup/set_serverId.ldif.sh ${SERVER_ID}
ONBUILD RUN rm /tmp/setup/set_serverId.ldif.sh
# Apply server Id settings
ONBUILD USER openldap
ONBUILD RUN slapmodify -b cn=config -l /tmp/setup/set_serverId.ldif
ONBUILD USER root
# ONBUILD RUN rm /tmp/setup/set_serverId.ldif

# Create ldif for provider setup
ONBUILD COPY /shared_scripts/setup_provider.ldif.sh /tmp/setup
ONBUILD RUN /tmp/setup/setup_provider.ldif.sh
ONBUILD RUN rm /tmp/setup/setup_provider.ldif.sh
# Apply provider settings
ONBUILD USER openldap
ONBUILD RUN slapmodify -b cn=config -l /tmp/setup/setup_provider.ldif
ONBUILD USER root
# ONBUILD RUN rm /tmp/setup/setup_provider.ldif

# Create ldif for which servers to sync
ONBUILD ARG SYNCSERVERS
ONBUILD ARG SYNC_DN
ONBUILD COPY /shared_scripts/add_sync_servers.ldif.sh /tmp/setup
ONBUILD RUN /tmp/setup/add_sync_servers.ldif.sh ${ROOTPASSWORD} ${SYNC_DN} ${SYNCSERVERS}
ONBUILD RUN rm /tmp/setup/add_sync_servers.ldif.sh
# Apply server sync settings
ONBUILD USER openldap
ONBUILD RUN slapmodify -b cn=config -l /tmp/setup/add_sync_servers.ldif
ONBUILD USER root
# ONBUILD RUN rm /tmp/setup/add_sync_servers.ldif

# Change file ownership from slapmodify user(root) to openldap user
ONBUILD RUN chown -R openldap:openldap /etc/ldap /var/lib/ldap
# ONBUILD USER openldap

CMD /tmp/entrypoint.sh