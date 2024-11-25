# Use Ubuntu as the base image
FROM base

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    sssd-ldap \
    sssd-krb5 \
    ldap-utils \
    krb5-user \
