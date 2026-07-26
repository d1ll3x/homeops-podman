#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

# Determine container runtime
if command -v podman >/dev/null 2>&1; then
  runtime="podman"
elif command -v docker >/dev/null 2>&1; then
  runtime="docker"
else
  echo "Error: a container runtime is required. Please install podman or docker" 1>&2
  exit 1
fi

# Set CWD to script location
cd "$(dirname "$0")"

butane_dir="./butane"
ignition_dir="./ignition"

# Generate Ignition files
configs=("$butane_dir"/*.bu)
for bu in "${configs[@]}"; do
  name="$(basename "$bu" .bu)"
  echo "Generating ${name}.ign..."
  "$runtime" run -i --rm quay.io/coreos/butane:release \
    --pretty --strict < "$bu" > "${ignition_dir}/${name}.ign"
  echo "SUCCESS! ${ignition_dir}/${name}.ign"
done

echo "Finished generating ignition files"
