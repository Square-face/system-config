{
  description = "SQ8 nixos system flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs-unstable, ...}: {nixosConfigurations = {
    shrexbox = import ./desktop.nix nixpkgs-unstable "shrexbox" "x86_64-linux";
  };};
}
