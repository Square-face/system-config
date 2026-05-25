nixpkgs: name: system: nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    {
      networking.hostName = name;
    }

    ./hosts/${name}.nix

    ./modules/system/systemd-boot.nix
    ./modules/system/networking.nix
    ./modules/system/locale.nix
    ./modules/system/nixos.nix
    ./modules/system/nh.nix
    ./modules/system/tlp.nix
    ./modules/system/graphics.nix
    ./modules/system/bluetooth.nix

    ./modules/system/sq8.nix

    ./modules/services/containers.nix
    ./modules/services/pipewire.nix
    ./modules/services/kerberos.nix
    ./modules/services/upower.nix
    ./modules/services/sshd.nix

    ./modules/programs/man.nix
    ./modules/programs/zsh.nix
  ];
}
