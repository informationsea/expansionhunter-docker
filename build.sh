#!/bin/bash

set -xeu -o pipefail

docker build -t informationsea/expansionhunter:5.0.0 .
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/output:/output \
    --privileged -t --rm quay.io/singularity/docker2singularity:v3.10.5 \
    informationsea/expansionhunter:5.0.0
