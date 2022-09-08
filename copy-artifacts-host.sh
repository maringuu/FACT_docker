#!/bin/sh
set -e

fact_path=~/workspace/git/fkie-cad/FACT_core

# We have to set HOME to some writable directory to successfully execute `git config`
# Also we change the user to the current use to have the correct permissions
docker run \
    --rm \
    -it \
    -v $fact_path:/opt/FACT_core \
    --env=HOME=/tmp \
    --entrypoint /copy-artifacts.sh \
    --user $(id -u):$(id -g) \
    fact-dev

