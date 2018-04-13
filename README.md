Unbound
---------

## About

Unbound: a validating, recursive, and caching DNS resolver that supports DNSSEC
This docker aim to simplify setup for unbound for following use cases:

- caching
- dnsspoof
- anti-advertisement


## How-to


Pull image

    docker pull pqatsi/unbound-recursive

Run it:

    docker run -it --rm -p 53:53 -p 53:53/udp pqatsi/unbound-recursive

With Verbosity:

    docker run -it --rm -p 53:53 -p 53:53/udp \
                  pqatsi/unbound-recursive unbound -d -vv

Run with block_ads list and one thread:

    docker run -it --rm -p 53:53 -p 53:53/udp \
                  -e "BLOCK_ADS=yes"  \
                  -e "NUM_THREADS=1" \
                  pqatsi/unbound-recursive


## Configuration

## Dnsspoof with yoyo.org/benstasker.co.uk, anti-advertising list

Yoyo.org supplies a list of known advertising servers in a convenient text file which is updated periodically and pre-formated for unbound. The list will configure Unbound to redirect the ad server hostnames to localhost (127.0.0.1).

Unbound will then redirect all 2400+ advertising servers to localhost keeping most, if not all advertising away from your systems

> NOTE: Make sure you remove any "local-zone" entries that may be duplicated in the Yoyo ad server list. For example, if you have "local-zone: "doubleclick.net" redirect" in the unbound.conf and yoyo has the same "local-zone: "doubleclick.net" redirect" in their list then Unbound will fail to start due to the conflict.

Following script will fetch new add server list and put it in unbound directory,
followed by unbount reload, if unbound running as server

    block_ads_server.sh

## Optimization

Read at undersigned url for various optimization settings:

    source https://www.unbound.net/documentation/howto_optimise.html

## Todo

- Add DNSCrypt wrapper
- Fix num-thread bug. Currently only 1 thread supported,else it crash


## Credits & Resources

- https://calomel.org/unbound_dns.html

