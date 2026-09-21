{ config, lib, ... }:
{
  options.flakes.enable = lib.mkEnableOption "Enable flakes";
  config = lib.mkIf config.flakes.enable {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
