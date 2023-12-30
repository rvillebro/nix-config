# Initializes nixos-test NixOS

# create partitions
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root ext4 512MB -4GB
parted /dev/sda -- mkpart swap linux-swap -4GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

# format and mount partitions
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
swapon /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/boot /mnt/boot/efi

# install nixos-test NixOS
nixos-install --flake github:rvillebro/nix-config#nixos-test
