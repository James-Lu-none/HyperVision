#!/usr/bin/env bash

set -eux

# ninja


ARR=(
    "agentinject"
    "codeinject"
    "csfr"
    "oracle"
    "paraminject"
    "persistence"
    "scrapy"
    "sslscan"
    "webshell"
    "xss"
)

for item in ${ARR[@]}; do
    docker run --rm \
    -v "$(pwd)/data:/HyperVision/data" \
    -v "$(pwd)/temp:/HyperVision/temp" \
    -v "$(pwd)/cache:/HyperVision/cache" \
    hypervision:latest \
    -c "./HyperVision -config ../configuration/web/${item}.json > ../cache/${item}.log"
done

cd ./result_analyze
./batch_analyzer.py -g web
cat ./log/web/*.log | grep AU_ROC
cd -