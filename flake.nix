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
    lib = import ./lib;
    # Work servers by class; each hostname gets a "rav@<hostname>"
    # homeConfigurations entry, which the home-manager CLI picks up via
    # its default $USER@$HOSTNAME lookup.
    workServerCpuHostnames = [
      "utopia-1"
      "utopia-2"
      "utopia-3"
      "utopia-4"
      "utopia-5"
      "utopia-6"
      "utopia-7"
    ];
    workServerGpuHostnames = [
      "acadia-1"
      "oblivion-1"
      "oblivion-2"
    ];
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs {pkgs = nixpkgs.legacyPackages.${system};});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules you might want to export
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    nixosConfigurations = {
      xps13 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/xps13];
      };
      rpi4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/rpi4];
      };
      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/nixos-wsl];
      };
    };

    # Standalone home-manager configuration entrypoint
    homeConfigurations = let
      mkServerHome = leaf: hostname: {
        name = "rav@${hostname}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [leaf];
        };
      };
    in
      {
        "rav@home" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [./users/rav/home.nix];
        };
        "rav@work" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [./users/rav/work.nix];
        };
      }
      // builtins.listToAttrs (
        map (mkServerHome ./users/rav/work-server-cpu.nix) workServerCpuHostnames
        ++ map (mkServerHome ./users/rav/work-server-gpu.nix) workServerGpuHostnames
      );
  };
}
