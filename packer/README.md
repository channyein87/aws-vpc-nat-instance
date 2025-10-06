# Packer template to build a NAT instance AMI on AL2023

This configuration builds an Amazon Linux 2023 (AL2023) AMI with NAT instance settings:

- Installs iptables-services
- Enables and starts iptables
- Configures persistent IP forwarding
- Applies NAT rules for eth0

## Usage

1. Ensure you have [Packer](https://www.packer.io/) (v1.7.0 or later) and AWS credentials configured.
2. Run the build using the HCL2 template:

```sh
cd packer
packer init .
packer build packer.pkr.hcl
```
