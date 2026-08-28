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
    # special hardware configurations
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = import ./lib {inherit inputs nixpkgs home-manager outputs;};
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
      xps13 = lib.mkHost {
        hostName = "xps13";
        system = "x86_64-linux";
        module = ./hosts/xps13;
        users = {rav = ./users/rav/xps13.nix;};
      };
      rpi4 = lib.mkHost {
        hostName = "rpi4";
        system = "aarch64-linux";
        module = ./hosts/rpi4;
        users = {rav = ./users/rav/rpi4.nix;};
      };
      nixos-wsl = lib.mkHost {
        hostName = "nixos-wsl";
        system = "x86_64-linux";
        module = ./hosts/nixos-wsl;
        users = {rav = ./users/rav/nixos-wsl.nix;};
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "rav@home" = lib.mkHome {
        system = "x86_64-linux";
        modules = [./users/rav/home.nix];
      };
      "rav@work" = lib.mkHome {
        system = "x86_64-linux";
        modules = [./users/rav/work.nix];
      };
    };
  };
}
