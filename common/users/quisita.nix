{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.quisita;
in
{
  options.quisita = {
    enable = lib.mkEnableOption "Enable Quisita's user";
    trust = lib.mkEnableOption  "Trust Quisita";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.password-quisita.file = ../../secrets/password-quisita.age;

    unfree.enable = true;
    unfree.allowed = ["discord" "discord-unwrapped"];

    kde.enable = true;
    kde.enableUtilsFor = ["quisita"];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    users.users.quisita = {
      description = "Quisita";
      uid = 1002;
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

      hashedPasswordFile = config.age.secrets.password-quisita.path;

      shell = pkgs.bash;
      packages = with pkgs; [
        firefox
        discord
        bitwarden-desktop
      ];
    };

    nix.settings.trusted-users = lib.mkIf cfg.trust [ "quisita" ];
  };
}
