# local-vps

Local QEMU/KVM Ubuntu VM configured to behave like a small VPS.

- VM directory: `~/local-vps`
- SSH endpoint: `vps@127.0.0.1:2222`
- Disk: `~/local-vps/disks/local-vps.qcow2` (100 GB virtual size)
- CPU/RAM defaults: 8 vCPU, 32768 MB RAM

## Setup

Prerequisites:

- Linux host with KVM available at `/dev/kvm`
- Nix with `nix-shell`, or installed `qemu-img`, `qemu-system-x86_64`, and `cloud-localds`
- An SSH public key at `~/.ssh/id_ed25519.pub` or `~/.ssh/id_rsa.pub`

Create the VM disk and cloud-init seed:

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

Inside the VM, install services with Ubuntu tools, for example:

```sh
sudo apt update
sudo apt install nginx
```

Generated VM state is intentionally not tracked by git. This includes images,
disks, logs, `known_hosts`, `seed/user-data`, and `seed/seed.img`.
