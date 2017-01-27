# lancache-sniproxy

Pass through HTTPS requests (uncacheable) to upstream servers

# Use Case

If you are running a lancache, some content providers will request some content via HTTPS, and HTTPS cannot be cached without installing an untrusted certificate on every client device.

Examples of content requested via HTTPS:

* Origin Downloader, and its updates (served from https://origin-a.akamaihd.net/[...])
* League of Legends Downloader, and its updates (served from https://riotgamespatcher-a.akamaihd.net/[...])

When running a lancache, the above domains resolve to your lancache's IP address, and a HTTPS request would time out as Nginx is not set up to listen for HTTPS requests. This leaves clients unable to download or update content unless they change their DNS servers and bypass the lancache entirely!

By using sniproxy and the lancache configuration file, requests from client machines to content providers over HTTPS will be proxied to the upstream server and fulfilled.

# Installation

Clone this repository

`mkdir -p /var/git && cd /var/git && git clone https://github.com/zeropingheroes/lancache-sniproxy.git`

Clone the sniproxy repository

`cd /usr/local/src/ && git clone https://github.com/dlundquist/sniproxy.git && cd sniproxy`

Install dependencies for sniproxy

`sudo apt-get install autotools-dev cdbs debhelper dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev libudns-dev pkg-config`

Compile Debian package for sniproxy

`./autogen.sh && dpkg-buildpackage`

Install the Debian package

`sudo dpkg -i ../sniproxy_0.4.0+git.29.gb2f0b34_amd64.deb`

Move the default configuration file

`mv /etc/sniproxy.conf /etc/sniproxy.conf.orig`

Install the lancache sniproxy configuration file

`ln -s /var/git/lancache-sniproxy/etc/sniproxy.conf /etc/sniproxy.conf`

Set sniproxy to start at boot

`systemctl enable sniproxy`

# Updating

Simply update git

Run `git pull` in `/var/git/lancache-sniproxy`

Then restart sniproxy

`systemctl restart sniproxy`

## Installation Problems

If you get a dependency error during compilation for PCRE, set this flag to ignore libraries compiled from source.
This error is a result of compiling PCRE from source.

`export DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info`

