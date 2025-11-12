#!/usr/bin/env bash

set -eux

BASE_NAME=$(basename $(pwd))

if [ $BASE_NAME != "HyperVision" ] && [ $BASE_NAME != "hypervision" ]; then
    echo "This script should be executed in the root dir of HyperVision."
    exit -1
fi

# create necessary directories
mkdir -p cache
mkdir -p temp

# check directories
if [ ! -d "./data" ]; then
    echo "data/ directory not found! Please run ./script/download_dataset.sh first."
    exit -1
fi

# run HyperVision.
./script/run_all_brute.sh
./script/run_all_lrscan.sh
./script/run_all_malware.sh
./script/run_all_misc.sh
./script/run_all_web.sh

echo "Done."
