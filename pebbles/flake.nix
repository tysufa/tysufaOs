{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=26.05";
    copyparty.url = "github:9001/copyparty";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations.pebbles = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        ./services.nix
        ./sops.nix
        ./cloudflare_tunnel.nix
        ./backups.nix
        ./fireshare.nix
        ./nginx.nix

	inputs.copyparty.nixosModules.default
        ({ pkgs, ... }: {
          # add the copyparty overlay to expose the package to the module
          nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
          # (optional) install the package globally
          environment.systemPackages = [ pkgs.copyparty ];
          # configure the copyparty module
          services.copyparty.enable = true;
        })
	./copyparty.nix
      ];
    };
  };
}

