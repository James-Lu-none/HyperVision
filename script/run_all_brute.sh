#!/usr/bin/env bash

set -eux

# ninja

ARR=(
    "charrdos"
    "cldaprdos"
    "dnsrdos"
    "dnsscan"
    "httpscan"
    "httpsscan"
    "icmpscan"
    "icmpsdos"
    "memcachedrdos"
    "ntprdos"
    "ntpscan"
    "riprdos"
    "rstsdos"
    "sqlscan"
    "ssdprdos"
    "sshscan"
    "synsdos"
    "udpsdos"
)

for item in ${ARR[@]}; do
    docker run --rm \
    -v "$(pwd)/data:/HyperVision/data" \
    -v "$(pwd)/temp:/HyperVision/temp" \
    -v "$(pwd)/cache:/HyperVision/cache" \
    hypervision:latest \
    -c "./HyperVision -config ../configuration/bruteforce/${item}.json > ../cache/${item}.log"
done
