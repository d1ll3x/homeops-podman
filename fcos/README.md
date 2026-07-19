# Fedora CoreOS Ignition Configuration

This directory contains the Butane source files and generated Ignition files for Fedora CoreOS deployments.

## Generate Ignition files

1. Modify the .bu files to your needs
2. Run the build script:

```bash
./build.sh
```

## Finalizing installation

Refer to `installer.ign` in your installation to pull `coreos.ign` from Github.

