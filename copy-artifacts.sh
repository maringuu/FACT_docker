#!/bin/sh
set -e

# TODO assert that the thing is mounted
# TODO rename script to sth. like copy-artifacts-container.sh

# The directory is owned by fact:fact in the container. Git otherwise complains about dubious permissions.
git config --global --add safe.directory /opt/FACT_core-from-container

# All files that are installed by the installer ignoring everyhing that will not work outside of the container
installed_files=$(cd /opt/FACT_core-from-container/ && git ls-files \
    --others \
    --exclude="__pycache__" \
    --exclude="start_fact_backend" \
    --exclude="start_fact_frontend" \
    --exclude="start_all_installed_fact_components" \
)

# TODO what of -a do we need
for file in $installed_files; do
    # If directorys get created they have to exists
    mkdir -p $(dirname /opt/FACT_core/$file)
    cp -r /opt/FACT_core-from-container/$file /opt/FACT_core/$file
    printf $file'\n'
done
