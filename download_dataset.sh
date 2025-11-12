#!/usr/bin/env bash

set -eux

BASE_NAME=$(basename $(pwd))

if [ $BASE_NAME != "HyperVision" ] && [ $BASE_NAME != "hypervision" ]; then
    echo "This script should be executed in the root dir of HyperVision."
    exit -1
fi

# Download dataset.
wget https://hypervision-publish.s3.cn-north-1.amazonaws.com.cn/hypervision-dataset.tar.gz
tar -xxf hypervision-dataset.tar.gz
rm $_