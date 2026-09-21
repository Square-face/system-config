{ config, lib, ... }: {
  imports = [
    ./kde.nix
    ./obs.nix
    ./manpages.nix
  ];

  options.nh.enable = lib.mkEnableOption "Enable nh";
  config = {
    programs.nh.enable = config.nh.enable;
  };
}
