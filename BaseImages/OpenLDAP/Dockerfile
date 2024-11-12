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

CMD /tmp/entrypoint.sh