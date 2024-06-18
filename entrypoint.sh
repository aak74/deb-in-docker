#!/bin/bash

# Clear out the /build and /release directory
rm -rf /build/*
rm -rf /release/*

# Re-pull the repository
git fetch && \
    BUILD_VERSION=$(git describe --tags $(git rev-list --tags --max-count=1)) && \
    git checkout ${BUILD_VERSION}

# Configure, make, make install
./autogen.sh && ./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --localstatedir=/var \
    --mandir=/usr/share/man \
    --with-openssl
make
fakeroot make install DESTDIR=/build

# GZip the Man pages
gzip /build/usr/share/man/man1/s3fs.1

# Get the Install Size
INSTALL_SIZE=$(du -s /build/usr | awk '{ print $1 }')

# Make DEBIAN directory in /build
mkdir -p /build/DEBIAN

# Copy the control file from resources
cp /src/resources/control.in /build/DEBIAN/control

# Fill in the information in the control file
sed -i "s/__VERSION__/${BUILD_VERSION:1}/g" /build/DEBIAN/control
sed -i "s/__FILESIZE__/${INSTALL_SIZE}/g" /build/DEBIAN/control

# Build our Debian package
fakeroot dpkg-deb -b "/build"

# Move it to release
mv /build.deb /release/s3fs-fuse-${BUILD_VERSION}-amd64.deb

ls -lah /release/
echo "package moved to release directory"