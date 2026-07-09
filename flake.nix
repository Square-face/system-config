{
  description = "SQ8 nixos system flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations = {
        shrexbox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./shrexbox/default.nix
            ./common/system/sq8.nix

            ./common/system/steering-wheel.nix
            ./common/system/systemd-boot.nix
            ./common/system/bluetooth.nix
            ./common/system/graphics.nix
            ./common/system/locale.nix
            ./common/system/nixos.nix
            ./common/system/nh.nix

            ./common/services/containers.nix
            ./common/services/pipewire.nix
            ./common/services/kerberos.nix
            ./common/services/upower.nix
            ./common/services/sshd.nix

            ./common/programs/man.nix
            ./common/programs/zsh.nix
            ./common/programs/steam.nix
          ];
        };

        flappy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./flappy/default.nix
            ./common/system/sq8.nix

            ./common/system/systemd-boot.nix
            ./common/system/networking.nix
            ./common/system/bluetooth.nix
            ./common/system/graphics.nix
            ./common/system/locale.nix
            ./common/system/nixos.nix
            ./common/system/nh.nix
            ./common/system/tlp.nix

            ./common/services/pipewire.nix
            ./common/services/kerberos.nix
            ./common/services/upower.nix
            ./common/services/sshd.nix

            ./common/programs/man.nix
            ./common/programs/zsh.nix
          ];
        };

        frank = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./frank/default.nix
            ./common/system/sq8.nix

            ./common/system/systemd-boot.nix
            ./common/system/rootbash.nix
            ./common/system/metrics.nix
            ./common/system/locale.nix
            ./common/system/nixos.nix
            ./common/system/nh.nix

            ./common/services/containers.nix
            ./common/services/sshd.nix
            ./common/services/weechat.nix

            ./common/programs/man.nix
            ./common/programs/zsh.nix
          ];
        };
      };
    };
}
