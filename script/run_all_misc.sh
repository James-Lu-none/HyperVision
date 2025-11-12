#!/usr/bin/env bash

set -eux

# ninja


ARR=(
    "sshpwdsm"
    "sshpwdmd"
    "sshpwdla"
    "telnetpwdsm"
    "telnetpwdmd"
    "telnetpwdla"
    "spam1"
    "spam50"
    "spam100"
    "crossfiresm"
    "crossfiremd"
    "crossfirela"
    "lrtcpdos02"
    "lrtcpdos05"
    "lrtcpdos10"
    "ackport"
    "ipidaddr"
    "ipidport"
)

for item in ${ARR[@]}; do
    docker run --rm \
    -v "$(pwd)/data:/HyperVision/data" \
    -v "$(pwd)/temp:/HyperVision/temp" \
    -v "$(pwd)/cache:/HyperVision/cache" \
    hypervision:latest \
    -c "./HyperVision -config ../configuration/misc/${item}.json > ../cache/${item}.log"
done

cd ./result_analyze
./batch_analyzer.py -g misc
cat ./log/misc/*.log | grep AU_ROC
cd -