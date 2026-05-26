# local-vps

Local QEMU/KVM NixOS VM configured to behave like a small VPS.

- VM directory: `~/local-vps`
- SSH endpoint: `vps@127.0.0.1:2222`
- Disk: `~/local-vps/disks/local-vps.qcow2` (100 GB virtual size)
- CPU/RAM defaults: 8 vCPU, 32768 MB RAM

## Setup

Prerequisites:

- NixOS host with KVM available at `/dev/kvm`
- Nix with flakes enabled
- An SSH public key at `~/.ssh/id_ed25519.pub` or `~/.ssh/id_rsa.pub`

Create the VM disk:

```sh
~/local-vps/bin/init-vm
```

Install the user systemd service:

```sh
mkdir -p ~/.config/systemd/user
cp ~/local-vps/systemd/local-vps.service ~/.config/systemd/user/
systemctl --user daemon-reload
```

Common commands:

```sh
~/local-vps/bin/vps start
~/local-vps/bin/vps ssh
~/local-vps/bin/vps stop
~/local-vps/bin/vps status
~/local-vps/bin/vps log
```

## Customizing the VM

Edit `nixos/configuration.nix` to add packages, services, or other NixOS
options. To apply changes, rebuild the image and recreate the disk:

```sh
~/local-vps/bin/vps stop
rm ~/local-vps/disks/local-vps.qcow2
~/local-vps/bin/init-vm
~/local-vps/bin/vps start
```

Or apply changes live inside the VM by copying the configuration and running
`nixos-rebuild switch`.
