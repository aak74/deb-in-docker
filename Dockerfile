FROM ubuntu:trusty

# Volumes
VOLUME /build
VOLUME /release

# Install build dependencies
RUN apt-get update && apt-get -y install \
    build-essential \
    devscripts \
    fakeroot \
    debhelper \
    automake \
    autotools-dev \
    pkg-config \
    git \
    ca-certificates \
    --no-install-recommends

# Install application dependencies
RUN apt-get -y install \
    libcurl4-gnutls-dev \
    libfuse-dev \
    libssl-dev \
    libxml2-dev \
    --no-install-recommends

# clone s3fs-fuse
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git /src
WORKDIR /src
RUN git fetch

# Import resources
COPY ./resources /src/resources
COPY ./entrypoint.sh /entrypoint.sh

# Make Executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]