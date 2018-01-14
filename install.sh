#!/bin/bash

# Exit if there is an error
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# If script is executed as an unprivileged user
# Execute it as superuser, preserving environment variables
if [ $EUID != 0 ]; then
    sudo -E "$0" "$@"
    exit $?
fi

# Install required packages
/usr/bin/apt update -y
/usr/bin/apt install -y autotools-dev \
                        cdbs \
                        debhelper \
                        dh-autoreconf \
                        dpkg-dev \
                        gettext \
                        libev-dev \
                        libpcre3-dev \
                        libudns-dev \
                        pkg-config

# Get sniproxy from Github
rm -rf /var/git/sniproxy
mkdir -p /var/git/sniproxy
/usr/bin/git clone https://github.com/dlundquist/sniproxy.git /var/git/sniproxy

# Apply fix for dpkg-buildpackage for PCRE
export DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info

# Compile sniproxy .deb package
cd /var/git/sniproxy/ && /var/git/sniproxy/autogen.sh && /usr/bin/dpkg-buildpackage

# Move the compiled .deb packages etc to a temporary directory
rm -rf /tmp/sniproxy
mkdir -p /tmp/sniproxy
cd /var/git && rm -f *-dbg* *.xz *.dsc *.changes && mv *.deb /tmp/sniproxy

# Install the package
/usr/bin/dpkg -i /tmp/sniproxy/*.deb

# Move the example configuration file
mv /etc/sniproxy.conf /etc/sniproxy.conf.example

# Install the configuration file
ln -s $SCRIPT_DIR/configs/sniproxy.conf /etc/sniproxy.conf

# Remove the defaults file (which by default contains ENABLED=0)
rm -f /etc/defaults/sniproxy

# Set the service to run at boot
/bin/systemctl enable sniproxy

# Start sniproxy
/bin/systemctl start sniproxy

