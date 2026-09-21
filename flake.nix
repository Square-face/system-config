{
  description = "SQ8 nixos system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      agenix,
      disko,
      ...
    }:
    let
      extras = import ./lib { lib = nixpkgs.lib; };
      system = "x86_64-linux";
      common = system: [
        ./modules

        disko.nixosModules.disko
        agenix.nixosModules.default
        {
          environment.systemPackages = [ agenix.packages."${system}".default ];
        }
      ];
    in
    {
      nixosConfigurations = {
        shrexbox = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit extras; };

          modules = [
            ./shrexbox
          ]
          ++ common system;
        };

        flappy = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit extras; };

          modules = [
            ./flappy
          ]
          ++ common system;
        };

        frank = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit extras; };

          modules = [
            ./frank
          ]
          ++ common system;
        };
      };
    };
}
