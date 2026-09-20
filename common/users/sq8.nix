{
  lib,
  pkgs,
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
    swaylock = lib.mkOption {
      description = "Enable swaylock pam service";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.password-sq8.file = ../../secrets/password-sq8.age;

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
    security.pam.services.swaylock = lib.mkIf cfg.swaylock { };
  };
}
