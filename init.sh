#!/usr/bin/env bash

set -eux

BASE_NAME=$(basename $(pwd))

if [ $BASE_NAME != "HyperVision" ] && [ $BASE_NAME != "hypervision" ]; then
    echo "This script should be executed in the root dir of HyperVision."
    exit -1
fi

# run HyperVision.
./script/expand.sh
cd build && ../script/run_all_brute.sh && cd ..

# Analyze the results.
cd ./result_analyze
./batch_analyzer.py -g brute
cat ./log/brute/*.log | grep AU_ROC
cd -

echo "Done."
