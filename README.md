# Purified DNS

A DNS forward server offers correct results for both GFW polluted domains and CDN-enabled domains in China.

It does **NOT** rely on any domain/ip database (e.g. GFWlist, GeoIP etc), maintenance free, highly reliable.

## Installation

With ruby >= 2.4.2 installed on your system, run the command below in your terminal(*nix) or CMD box:

`gem install prdns`

## Usage

- local test purpose only: run '`prdns`'
- local server: run '`prdns -l localhost`'
- public server or for intranet: run '`prdns -l 0.0.0.0`', or '`prdns -l 0.0.0.0 -l [::]`' for both ipv4 & ipv6

Run `prdns -h' for more help

### Run as Service
- linux-like: use of [supervisord](http://supervisord.org/) is recommended.
- macOS: use the plist file included in gem's `lib` dir as a template for `launchd`.

### Notes:
prdns does NOT support DoH nor DoT, so there are three choices for picking an authentic upstream DNS server (-a):
1. A DNS server outside GFW listen on port other than 53 (currently, only port 53 gets polluted);
2. There's a trustful route (via Shadowsocks/V2ray/Trojan, etc) accessing a DNS server outside GFW;
3. A local DNS forward server which supports DoH or DoT, configured with a DoH or DoT enabled upstream DNS server outside GFW.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arloan/prdns.
