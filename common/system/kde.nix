{ config, lib, pkgs, ... }: let
  cfg = config.kde;
in {
  options.kde = {
    enable = lib.mkOption {
      description = "Enable kde plasma";
      type = lib.types.bool;
      default = false;
    };

    enableGlobalUtils = lib.mkOption {
      description = "Enable kde plasma utils globaly";
      type = lib.types.bool;
      default = false;
    };

    enableUtilsFor = lib.mkOption {
      description = "Enable kde plasma utils for listed users";
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };
  config = let
    utils = (with pkgs; [
      kdePackages.kcalc             # Calculator
      kdePackages.kclock            # Clock app
      kdePackages.discover          # Software center for Flatpaks/firmware updates
      kdePackages.ksystemlog        # System log viewer
      kdePackages.kcharselect       # Character map
      kdePackages.kolourpaint       # Simple paint program
      kdePackages.kcolorchooser     # Color picker
      kdePackages.isoimagewriter    # Write hybrid ISOs to USB
      kdePackages.partitionmanager  # Disk and partition management
    ]);
  in lib.mkIf cfg.enable  {
    services.desktopManager.plasma6.enable = lib.mkDefault true;

    environment.systemPackages = lib.mkIf cfg.enableGlobalUtils utils;
    users.users = lib.attrsets.genAttrs cfg.enableUtilsFor (u: {packages = utils;});
  };
}
