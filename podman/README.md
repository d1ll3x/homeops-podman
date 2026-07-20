# Fedora CoreOS Ignition Configuration

This directory contains the Butane source file and generated Ignition file for Fedora CoreOS deployments on Proxmox VE.

## Generate Ignition files

1. Modify the .bu files to your needs
2. Run the build script:

```bash
./build.sh
```

## Prepare Proxmox VE

We need to let Proxmox pass the ignition file to our virtual machine. We can do this through cloud-init and by using snippets.

Follow [the official instructions](https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-proxmoxve) to set this up.
