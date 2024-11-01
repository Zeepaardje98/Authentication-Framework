# Use Ubuntu as the base image
FROM ubuntu:24.04

# Set environment variables for non-interactive apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    # For network testing commands
    iputils-ping \
    netcat-openbsd \
    dnsutils

CMD /tmp/entrypoint.sh