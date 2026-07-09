{
  description = "SQ8 nixos system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    {
      nixpkgs,
      agenix,
      ...
    }:
    let
      system = "x86_64-linux";
      age = system: [
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
          specialArgs = {
            vars = import ./shrexbox/variables.nix;
          };

          modules = [
            ./shrexbox/default.nix
            ./common/system/sq8.nix

            ./common/system/steering-wheel.nix
            ./common/system/systemd-boot.nix
            ./common/system/shitcloud-wg.nix
            ./common/system/bluetooth.nix
            ./common/system/graphics.nix
            ./common/system/ludd-ca.nix
            ./common/system/locale.nix
            ./common/system/nix-ld.nix
            ./common/system/nixos.nix
            ./common/system/nh.nix

            ./common/services/containers.nix
            ./common/services/pipewire.nix
            ./common/services/kerberos.nix
            ./common/services/upower.nix
            ./common/services/sshd.nix
            ./common/services/xdg.nix

            ./common/programs/man.nix
            ./common/programs/zsh.nix
            ./common/programs/steam.nix
          ]
          ++ age system;
        };

        flappy = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            vars = import ./flappy/variables.nix;
          };

          modules = [
            ./flappy/default.nix
            ./common/system/sq8.nix

            ./common/system/systemd-boot.nix
            ./common/system/shitcloud-wg.nix
            ./common/system/networking.nix
            ./common/system/bluetooth.nix
            ./common/system/graphics.nix
            ./common/system/ludd-ca.nix
            ./common/system/locale.nix
            ./common/system/nix-ld.nix
            ./common/system/nixos.nix
            ./common/system/tlp.nix
            ./common/system/nh.nix

            ./common/services/pipewire.nix
            ./common/services/kerberos.nix
            ./common/services/upower.nix
            ./common/services/sshd.nix
            ./common/services/xdg.nix

            ./common/programs/man.nix
            ./common/programs/zsh.nix
          ] ++ age system;
        };

        frank = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            vars = import ./frank/variables.nix;
          };

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

          ]
          ++ age system;
        };
      };
    };
}
