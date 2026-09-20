{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.secoffee;
in
{
  options.secoffee = {
    enable = lib.mkEnableOption "Enable Secoffee's user";
    trust = lib.mkEnableOption "Trust Secoffee";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.password-secoffee.file = ../../secrets/password-secoffee.age;

    unfree.enable = true;
    unfree.allowed = ["discord" "discord-unwrapped"];

    kde.enable = true;
    kde.enableUtilsFor = ["secoffee"];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    users.users.secoffee = {
      description = "Certified Food Tistic";
      uid = 1003;
      isNormalUser = true;
      isSystemUser = lib.mkForce false;

      extraGroups = [
        "networkmanager"
        "seat"
        "render"
        "video"
        "audio"
        "kvm"
        "uinput"
        "input"
      ];

      hashedPasswordFile = config.age.secrets.password-secoffee.path;

      shell = pkgs.bash;
      packages = with pkgs; [
        firefox
        discord
        bitwarden-desktop
      ];
    };

    nix.settings.trusted-users = lib.mkIf cfg.trust [ "secoffee" ];
  };
}
