FROM osixia/openldap:1.5.0

# Update and install necessary packages
# RUN apt-get update && \
#     apt-get install -y \
#     krb5-user \
#     krb5-config \
#     libsasl2-modules-gssapi-mit

ARG LDAP_ORGANISATION
ARG LDAP_DOMAIN
ARG LDAP_ADMIN_PASSWORD

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


# Expose default LDAP ports
EXPOSE 389 636

CMD /tmp/entrypoint.sh