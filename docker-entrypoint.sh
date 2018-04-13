#!/bin/sh


SCRIPT_DIR="/var/unbound/scripts"

cd /etc/unbound

/etc/periodic/monthly/update-unbound-root-hints
unbound-anchor -a "/etc/unbound/root.key"

## Block Ads
if [ "$BLOCK_ADS" = "yes" ]
then
    . $SCRIPT_DIR/block_ads_server.sh
    # Get server list
    ##sed -i 's/#include: "\/etc\/unbound\/local.d\/unbound_ad_servers"/include: "\/etc\/unbound\/local.d\/unbound_ad_servers\"/' /etc/unbound/unbound.conf
fi

if [ ! -z "$CACHE_MIN_TTL" ]
then
    sed -i -E "s/(.*)cache-min-ttl: (.*)/cache-min-ttl: $CACHE_MIN_TTL/" /etc/unbound/unbound.conf
fi

if [ ! -z "$CACHE_MAX_TTL" ]
then
    sed -i -E "s/(.*)cache-max-ttl: (.*)/cache-max-ttl: $CACHE_MAX_TTL/" /etc/unbound/unbound.conf
fi

if [ ! -z "$NUM_THREADS" ]
then
    sed -i -E "s/(.*)num-threads: (.*)/num-threads: $NUM_THREADS/" /etc/unbound/unbound.conf
else
    ## Tweak num threads
    procs=$(cat /proc/cpuinfo |grep processor | wc -l)
    sed -i -E "s/(.*)num-threads: (.*)/num-threads: $procs/" /etc/unbound/unbound.conf
fi

## Sync clocks,else you'll get  "Fix failed to prime trust anchor" errors
## Host must set this, so commenting
#echo "Syncing clock with pool.ntp.org"
#ntpd -n -N -p pool.ntp.org

## Checkconf

unbound-checkconf || exit 1

## Start unbound if no args given
if [ "$#" -gt 0 ]
then
    $@
else
    unbound -d
fi
