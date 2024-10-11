FROM osixia/openldap:1.5.0

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    krb5-user

# Setup script
COPY entrypoint.sh /tmp/entrypoint.sh

CMD /tmp/entrypoint.sh