{
  lib,
  pkgs,
  extras,
  config,
  ...
}: let
  cfg = config.gaming.steam;
in {
  options.gaming.steam = with lib; with extras.options; {
    enable = mkEnableOption "Enable steam system wide";
    paranoid = mkEnableOption "Disables all firewall rules.";
    compatability = mkEnabledOption "Configures steam for better compatability";
    gamemode = mkEnabledOption "Enable gamemode";
    gamescope = mkEnabledOption "Enable gamescope";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = lib.mkDefault true;

      remotePlay.openFirewall = !cfg.paranoid;
      dedicatedServer.openFirewall = !cfg.paranoid;
      localNetworkGameTransfers.openFirewall = !cfg.paranoid;

      protontricks.enable = cfg.compatability;
      gamescopeSession.enable = cfg.compatability;
      extraCompatPackages = lib.mkIf cfg.compatability [ pkgs.proton-ge-bin ];
      extraPackages = with pkgs; [
        mangohud
      ];
    };

    programs.gamemode.enable = cfg.gamemode;

    programs.gamescope.enable = cfg.gamescope;
    programs.gamescope.capSysNice = true;

    services.pulseaudio.support32Bit = config.services.pulseaudio.enable;

    unfree.enable = true;
    unfree.allowed = [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
  };
}
