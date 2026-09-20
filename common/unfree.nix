{ lib, config, ... }:
let
  cfg = config.unfree;
in
{
  options.unfree = {
    enable = lib.mkOption {
      description = ''
        Enable unfree predicate

        Allows certain unfree programs to be installed.
      '';
      type = lib.types.bool;
      default = true;
    };
    allowed = lib.mkOption {
      description = ''
        List of program names to allow.
      '';
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];
    };
    allowAll = lib.mkOption {
      description = ''
        Allow all unfree programs, setting this to true makes unfree.allowed do nothing.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config.nixpkgs.config.allowUnfree = cfg.allowAll;
  config.nixpkgs.config.allowUnfreePredicate = lib.mkIf cfg.enable (
    pkg: builtins.elem (lib.getName pkg) cfg.allowed
  );
}
