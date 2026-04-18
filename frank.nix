nixpkgs: name: system: nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    ./hardware/${name}.nix

    ./modules/system/systemd-boot.nix
    ./modules/system/networking.nix
    ./modules/system/sq8.nix

    ./modules/services/containers.nix
    ./modules/services/sshd.nix

    ./modules/programs/man.nix
    ./modules/programs/zsh.nix
  ];
}
