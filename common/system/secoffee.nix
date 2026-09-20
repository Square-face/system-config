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
    enabled = lib.mkOption {
      description = "Enable Quisita's user";
      type = lib.types.bool;
      default = true;
    };
    trusted = lib.mkOption {
      description = "Trust Quisita";
      type = lib.types.bool;
      default = false;
    };
  };

  imports = [
    ../unfree.nix
  ];

  config = lib.mkIf cfg.enabled {
    unfree.enable = true;
    unfree.allowed = ["discord"];

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

    nix.settings.trusted-users = lib.mkIf cfg.trusted [ "secoffee" ];
  };
}
