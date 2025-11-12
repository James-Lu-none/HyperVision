#!/usr/bin/env bash

set -eux

# ninja


ARR=(
    "dns_lrscan"
    "http_lrscan"
    "icmp_lrscan"
    "netbios_lrscan"
    "rdp_lrscan"
    "smtp_lrscan"
    "snmp_lrscan"
    "ssh_lrscan"
    "telnet_lrscan"
    "vlc_lrscan"
)

for item in ${ARR[@]}; do
    docker run --rm \
    -v "$(pwd)/data:/HyperVision/data" \
    -v "$(pwd)/temp:/HyperVision/temp" \
    -v "$(pwd)/cache:/HyperVision/cache" \
    hypervision:latest \
    -c "./HyperVision -config ../configuration/lrscan/${item}.json > ../cache/${item}.log"
done
