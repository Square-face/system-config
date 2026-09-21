{
  lib,
  pkgs,
  extras,
  config,
  ...
}:
let
  cfg = config.sq8;
in
{
  options.sq8 = {
    enable = lib.mkEnableOption "Enable SQ8's user";
    trust = lib.mkEnableOption "Trust SQ8";
    niri = {
      xdg = extras.options.mkEnabledOption "Configure xdg for niri";
      swaylock = extras.options.mkEnabledOption "Enable swaylock pam service";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.password-sq8.file = ../../secrets/password-sq8.age;

    nix.settings.use-xdg-base-directories = lib.mkDefault true;
    xdg.portal = lib.mkIf cfg.niri.xdg {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = "*";
        niri."org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        niri.default = [ "gnome" "gtk" ];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome # Required for Niri screencasting
        xdg-desktop-portal-gtk # Required for file choosers
      ];
    };

    programs.zsh.enable = lib.mkDefault true;
    users.users.sq8 = {
      isNormalUser = true;
      isSystemUser = lib.mkForce false;
      uid = 1000;
      shell = pkgs.zsh;
      description = "Linus Michelsson";
      extraGroups = [
        "networkmanager"
        "seat"
        "render"
        "video"
        "audio"
        "wheel"
        "kvm"
        "podman"
        "nginx"
        "docker"
      ];

      hashedPasswordFile = config.age.secrets.password-sq8.path;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqqHUxxsUbO8rvzowMKuj/mRmp9zIe+yJMU7NNmqxkb linus@sq8.dev"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtqbcf79hftPjzRHZ3Vy/bGJTSYzdw9akVSzxI4WUyr linus@sq8.dev"
      ];
    };

    nix.settings.trusted-users = lib.mkIf cfg.trust [ "sq8" ];
    security.pam.services.swaylock = lib.mkIf cfg.niri.swaylock { };
  };
}
