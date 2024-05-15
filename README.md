# My nix-config

This is my nix configuration


# NixOS on XP13

To install fresh from NixOS minimal installer.
First initiate a sudo shell and load danish keys:

```bash
sudo -i
loadkeys dk
```

## Network

To set up wireless network, enter the `wpa_cli`:
```bash
systemctl start wpa_supplicant
wpa_cli
```
To add a network do the following:
```bash
add_network
set_network 0 ssid "<network name>"
set_network 0 psk "<network password>"
set_network 0 key_mgmt WPA-PSK
enable_network 0
```

## Partitioning

```bash
parted -a optimal /dev/nvme0n1 -- mklabel gpt
parted -a optimal /dev/nvme0n1 -- mkpart root ext4 512MB -8GB
parted -a optimal /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100%
parted -a optimal /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted -a optimal /dev/nvme0n1 -- set 3 esp on
```

## Formatting

```bash
mkfs.ext4 -L nixos /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3
```

## Installation

```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/boot /mnt/boot/efi
```