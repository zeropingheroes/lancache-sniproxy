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

1. `git clone https://github.com/zeropingheroes/lancache-sniproxy.git && cd lancache-sniproxy`

2. `./install.sh`

