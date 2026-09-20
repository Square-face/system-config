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
      system = "x86_64-linux";
      common = system: [
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

          modules = [
            ./common/default.nix
            ./shrexbox/default.nix

            ./common/system/steering-wheel.nix
            ./common/system/systemd-boot.nix
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
          ++ common system;
        };

        flappy = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./flappy/default.nix
            ./common/default.nix

            ./common/system/systemd-boot.nix
            ./common/system/networking.nix
            ./common/system/bluetooth.nix
            ./common/system/graphics.nix
            ./common/system/ludd-ca.nix
            ./common/system/locale.nix
            ./common/system/nix-ld.nix
            ./common/system/nixos.nix
            ./common/system/tlp.nix
            ./common/system/nh.nix

            ./common/services/containers.nix
            ./common/services/pipewire.nix
            ./common/services/kerberos.nix
            ./common/services/upower.nix
            ./common/services/sshd.nix
            ./common/services/xdg.nix

            ./common/programs/man.nix
            ./common/programs/zsh.nix
          ]
          ++ common system;
        };

        frank = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./frank/default.nix
            ./common/default.nix

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
          ++ common system;
        };
      };
    };
}
