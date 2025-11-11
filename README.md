# Docker Compose Web Deployment Example
This project provides an Ansible solution for deploying a simple web application (linux_tweet_app) using Docker Compose (for multi-container orchestration) and an Nginx reverse proxy acting as the entry point, onto a remote VM. This is intended to serve as a basic, reproducible example for deploying containerized web stacks.


## Project Workflow and Execution Model
This project uses Ansible to perform remote configuration and management on an existing, running Virtual Machine (VM).

### Key Points:
Remote Control: The Ansible playbooks act as a control node (your laptop/CI runner) to configure software on a separate, running VM (the target).

No VM Provisioning in Playbooks: The Ansible playbooks in this repository do not create the VM. They assume the target VM is already running and accessible via SSH.


## Prerequisites
### 1. Virtualization Host
You must have an SSH-accessible target VM ready for Ansible to manage. Choose the option below that matches your current setup:

Option A: Existing Ubuntu fresh VM. You can skip all creation steps and proceed directly to Step 2: Remote Management with Ansible. Ensure you have the VM's IP address and SSH credentials with sudo privileges

Option B: Remote libvirt/QEMU Host. Connect to the remote libvirtd daemon using the SSH-based URI format:

```bash

--connect qemu+ssh://YOUR_USER@YOUR_REMOTE_HOST/system
```

Option C: Local libvirt/QEMU Laptop (For simplified testing) Install the stack locally to create a target VM for testing:

Installation (Ubuntu/Debian Example):

```bash

sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virtinst
sudo usermod -aG libvirt $USER

```

### 1.1. Prepare Image and Cloud-Init Seed
```bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
cloud-localds seed.iso user-data meta-data
# optional
qemu-img resize noble-server-cloudimg-amd64.img 50G
```
### 1.2. Start the VM using virt-install
```bash
virt-install \
  --name ubuntu-cloud-vm-2 \
  --memory 2048 \
  --vcpus 2 \
  --disk path=noble-server-cloudimg-amd64.img,format=qcow2 \
  --disk path=seed.iso,device=cdrom,format=raw \
  --os-variant ubuntu23.10 \
  --graphics none \
  --console pty,target_type=serial \
  --import \
  --network network=default,model=virtio
```

### Step 2: Remote Management with Ansible
Check your inventory.ini for the correct IP/hostname*, and execute the playbook.

```bash
ansible-playbook -i inventory.ini playbook.yaml -vv
```

### 2.2. Verify Deployment
After the playbook successfully runs, the configured service (e.g., a web server) should be running on the target VM. You will verify this by checking that the example website is reachable by browsing to the VM's IP address.
