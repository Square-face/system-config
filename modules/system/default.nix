{ config, lib, ... }: {
  imports = [
    ./tlp.nix
    ./audio.nix
    ./unfree.nix
    ./metrics.nix
    ./rootbash.nix
    ./hardware.nix
    ./kerberos.nix
    ./ludd-ca.nix
    ./bootloader.nix
    ./locale.nix
    ./flakes.nix
  ];

  options.upower.enable = lib.mkEnableOption "Enable upower";
  options.docker.enable = lib.mkEnableOption "Enable docker daemon";
  config = {
    services.upower.enable = config.upower.enable;
    virtualisation.docker.enable = config.docker.enable;
  };
}
