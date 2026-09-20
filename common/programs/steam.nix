{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ../unfree.nix ];
  programs.gamemode.enable = lib.mkDefault true;

  programs.steam = {
    enable = lib.mkDefault true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = lib.mkDefault true;
    dedicatedServer.openFirewall = lib.mkDefault true;
  };

  services.pulseaudio.support32Bit = config.services.pulseaudio.enable;

  environment.systemPackages = with pkgs; [
    protontricks
    winetricks
    protonup-qt
    gamescope
    mangohud
  ];

  unfree.enable = true;
  unfree.allowed = [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];
}
