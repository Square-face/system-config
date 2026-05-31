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
    enabled = lib.mkOption {
      description = "Enable SQ8's user";
      type = lib.types.bool;
      default = true;
    };
    trusted = lib.mkOption {
      description = "Trust SQ8";
      type = lib.types.bool;
      default = true;
    };
    swaylock = lib.mkOption {
      description = "Enable swaylock pam service";
      type = lib.types.bool;
      default = true;
    };
  };

  config.security.pam.services.swaylock = lib.mkIf cfg.swaylock { };
  config.users.users.sq8 = lib.mkIf cfg.enabled {
    isNormalUser = true;
    isSystemUser = lib.mkForce false;
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
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqqHUxxsUbO8rvzowMKuj/mRmp9zIe+yJMU7NNmqxkb linus@sq8.dev cardno:19_628_687"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtqbcf79hftPjzRHZ3Vy/bGJTSYzdw9akVSzxI4WUyr linus@sq8.dev cardno:31_013_135"
    ];
  };

  config.nix.settings.trusted-users = lib.mkIf cfg.trusted [ "sq8" ];
}
