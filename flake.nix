{
  description = "SQ8 nixos system flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs = {nixpkgs-unstable, nixpkgs-stable, ...}: {
    nixosConfigurations = {
      shrexbox = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/shrexbox/default.nix
          ./modules/system/sq8.nix

          ./modules/system/systemd-boot.nix
          ./modules/system/networking.nix
          ./modules/system/bluetooth.nix
          ./modules/system/graphics.nix
          ./modules/system/locale.nix
          ./modules/system/nixos.nix
          ./modules/system/nh.nix

          ./modules/services/containers.nix
          ./modules/services/pipewire.nix
          ./modules/services/kerberos.nix
          ./modules/services/upower.nix
          ./modules/services/sshd.nix

          ./modules/programs/man.nix
          ./modules/programs/zsh.nix
          ./modules/programs/steam.nix
        ];
      };

      flappy = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/flappy/default.nix
          ./modules/system/sq8.nix

          ./modules/system/systemd-boot.nix
          ./modules/system/networking.nix
          ./modules/system/bluetooth.nix
          ./modules/system/graphics.nix
          ./modules/system/locale.nix
          ./modules/system/nixos.nix
          ./modules/system/nh.nix
          ./modules/system/tlp.nix

          ./modules/services/containers.nix
          ./modules/services/pipewire.nix
          ./modules/services/kerberos.nix
          ./modules/services/upower.nix
          ./modules/services/sshd.nix

          ./modules/programs/man.nix
          ./modules/programs/zsh.nix
        ];
      };

      frank = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/frank/default.nix
          ./modules/system/sq8.nix

          ./modules/system/systemd-boot.nix
          # ./modules/system/networking.nix
          ./modules/system/rootbash.nix
          ./modules/system/metrics.nix
          ./modules/system/nixos.nix
          ./modules/system/nh.nix

          ./modules/services/containers.nix
          ./modules/services/dnsmasq.nix
          ./modules/services/sshd.nix
          ./modules/services/weechat.nix

          ./modules/programs/man.nix
          ./modules/programs/zsh.nix
        ];
      };
    };
  };
}
