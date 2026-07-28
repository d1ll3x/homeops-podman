## 🔎 Overview

This is a mono repository for my podman driven home infrastructure. The goal is to implement Infrastructure as Code(IaC) and GitOps practices while keeping the overall setup as simple as possible.

---

## ⚙️ Tech stack

I am combining these platforms and tools that in my opinion work well with IaC and Gitops practices:

🖥 Hypervisor: `Proxmox`
💿 Operating System: `Fedora CoreOS`
📦 Container Engine: `Podman`
🛠️ Tools: `Terraform`

### 🖥 Proxmox

Proxmox offers automation several features such as:
- A well supported Proxmox Terraform Provider. 
- Native ignition support through cloud-init and snippets

This allows us to define the entire Fedora CoreOS (FCOS) virtual machine infrastructure as code within a Git repository.

### 💿 Fedora CoreOS

Fedora CoreOS (FCOS) is an open-source, automatically updating, minimal and ephemeral operating system designed specifically for running containerized workloads. FCOS has an immmutable filesystem. which means that all configuration is managed declaratively through ignition files (JSON). It comes pre-installed with Podman and Docker and optimized SELinux policies. To me this makes FCOS the perfect OS for running containers without requiring orchestration.

To generate ignition files it is a lot easier to first define them as butane files and then convert them. This process is basically a conversion from YAML to JSON. In the `fcos` directory you can find a `build.sh` script which does this conversion for you.
In here you can also find all the ignition files I use to run my quadlets rootless with data persistence.

### 📦️ Podman

I have chosen to run my application workloads on Podman.Podman is inherritently more secure by design compared to Docker since it runs daemonless and supports rootless out-of-the-box. In addition, I like the concept of `quadlets` where all my services just run as a (user) systemd service.

I am specifically running my container workloads `rootless` due to the inherritent security risk that comes from running containers as root. With Podman and FCOS this is as easy as configuring `podman` and `quadlets` at the `~/.config` directory.

### TODO: 🛠️ Terraform

Terraform is ideal to quickly rebuild the FCOS virtual machines and maintaining data persistence. This is achieved by detaching and re-attaching a secondary dedicated data disk for container workloads to FCOS.
