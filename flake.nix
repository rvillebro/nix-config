{
  description = "Rasmus' Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url =  "github:nix-community/NixOS-WSL/main";
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

    packages = forAllSystems (system: import ./pkgs {pkgs=nixpkgs.legacyPackages.${system};});
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
          inputs.hardware.nixosModules.raspberry-pi-4  # fix hardware quirks for Raspberry Pi 4
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
          ./home/rav-at-work
        ];
      };
      "rav@home" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/rav-at-home
        ];
      };
    };
  };
}
