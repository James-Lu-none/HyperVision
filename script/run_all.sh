#!/usr/bin/env bash

set -eux

BASE_NAME=$(basename $(pwd))

if [ $BASE_NAME != "HyperVision" ] && [ $BASE_NAME != "hypervision" ]; then
    echo "This script should be executed in the root dir of HyperVision."
    exit -1
fi

# create necessary directories
./script/expand.sh

# run HyperVision.
./script/run_all_brute.sh
./script/run_all_lrscan.sh
./script/run_all_malware.sh
./script/run_all_misc.sh
./script/run_all_web.sh

# Analyze the results.
cd ./result_analyze
./batch_analyzer.py -g brute
cat ./log/brute/*.log | grep AU_ROC
./batch_analyzer.py -g lrscan
cat ./log/lrscan/*.log | grep AU_ROC
./batch_analyzer.py -g malware
cat ./log/malware/*.log | grep AU_ROC
./batch_analyzer.py -g misc
cat ./log/misc/*.log | grep AU_ROC
./batch_analyzer.py -g web
cat ./log/web/*.log | grep AU_ROC

cd -

echo "Done."
