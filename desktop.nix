nixpkgs: name: system: nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    {
      networking.hostName = name;
      hardware.graphics.enable = true;
      security.pam.services.swaylock= {};
      hardware.bluetooth.enable = true;
    }

    ./hosts/${name}.nix

    ./modules/system/systemd-boot.nix
    ./modules/system/networking.nix
    ./modules/system/locale.nix
    ./modules/system/nixos.nix
    ./modules/system/nh.nix

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
