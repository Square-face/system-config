{
  description = "SQ8 nixos system flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs = {nixpkgs-unstable, nixpkgs-stable, ...}: {nixosConfigurations = {
    shrexbox = import ./desktop.nix nixpkgs-unstable "shrexbox" "x86_64-linux";

    flappy = import ./laptop.nix nixpkgs-unstable "flappy" "x86_64-linux";

    frank = nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/frank.nix

        ./modules/system/systemd-boot.nix
        ./modules/system/networking.nix
        ./modules/system/nixos.nix
        ./modules/system/nh.nix
        ./modules/system/rootbash.nix

        ./modules/system/sq8.nix

        ./modules/services/containers.nix
        ./modules/services/dnsmasq.nix
        ./modules/services/sshd.nix

        ./modules/programs/man.nix
        ./modules/programs/zsh.nix
      ];
    };
  };};
}
