{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    stablepkgs = inputs.nixpkgsstable.legacyPackages.${system};
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;}; # pass arguments to the modules
      modules = [
        stylix.nixosModules.stylix
        ./configuration.nix
      ];
    };

    homeConfigurations.tysufa = inputs.home-manager.lib.homeManagerConfiguration {
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        stylix.homeManagerModules.stylix
        ./home.nix
      ];
      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
