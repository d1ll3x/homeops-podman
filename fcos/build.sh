#!/bin/bash

set -euo pipefail

# Determine container runtime
if command -v podman >/dev/null 2>&1; then
  runtime="podman"
elif command -v docker >/dev/null 2>&1; then
  runtime="docker"
else
  echo "Error: a container runtime is required. Please install podman or docker" 1>&2
  exit 1
fi

# Generate Ignition files
for config in coreos; do
  echo "Generating ${config}.ign..."

  "$runtime" run -i --rm quay.io/coreos/butane:release \
    --pretty --strict < "./${config}.bu" > "./${config}.ign"
  echo "SUCCESS! ./${config}.ign"
done

echo "Finished generating ignition files"
