{
  description = "Rasmus' Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # special hardware confgurations
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: let pkgSet = import ./pkgs {pkgs = nixpkgs.legacyPackages.${system};}; in nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) pkgSet);
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      xps13 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          inputs.hardware.nixosModules.dell-xps-13-9370 # fix hardware quirks for XPS13
          inputs.home-manager.nixosModules.home-manager
          ./hosts/xps13
        ];
      };
      rpi4 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "aarch64-linux";
        modules = [
          inputs.hardware.nixosModules.raspberry-pi-4 # fix hardware quirks for Raspberry Pi 4
          inputs.home-manager.nixosModules.home-manager
          ./hosts/rpi4
        ];
      };
      nixos-wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          inputs.nixos-wsl.nixosModules.wsl
          inputs.home-manager.nixosModules.home-manager
          ./hosts/nixos-wsl
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "rav@work" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/common/nix.nix
          ./home/rav-at-work
        ];
      };
      "rav@home" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ({...}: {
            nix.settings = {
              extra-substituters = [
                "https://cache.numtide.com"
                "https://cache.nixos-cuda.org"
              ];
              extra-trusted-public-keys = [
                "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
                "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
              ];
            };
          })
          ./home/common/nix.nix
          ./home/rav-at-home
        ];
      };
    };

    # Standalone evaluation wrappers for each NixOS role profile, so the
    # profiles/nixos/* leaves can be verified with `nix eval` on both arches
    # independent of any host. This is the 'Seam B' check from spec #40: each
    # profile is bundled as its own anonymous system and evaluated on the paths
    # that prove its role placement.
    nixosProfiles = let
      lib = nixpkgs.lib;
      # Minimal canonical host anchor so each role profile evaluates as a
      # complete standalone system on both arches: `base` is a prerequisite for
      # every host (rav account, overlays), and a root fs + bootloader +
      # stateVersion satisfy NixOS' bootability assertions that a profile on its
      # own would not.
      anchor = {
        boot.loader.grub.devices = ["/dev/sda"];
        fileSystems."/" = {
          device = "/dev/sda1";
          fsType = "ext4";
        };
        system.stateVersion = "24.05";
      };
      probe = system: role:
        lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [./profiles/nixos/base.nix role anchor];
        };
      both = role: {
        x86_64-linux = probe "x86_64-linux" role;
        aarch64-linux = probe "aarch64-linux" role;
      };
    in {
      base = both {};
      desktop = both ./profiles/nixos/desktop.nix;
      server = both ./profiles/nixos/server.nix;
      media-server = both ./profiles/nixos/media-server.nix;
    };
  };
}
