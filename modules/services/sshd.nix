{
  config,
  extras,
  pkgs,
  lib,
  ...
}:
let
  banner = pkgs.writeText "banner" "Tagga fejden\n";
  cfg = config.sshd;
in
{
  options.sshd = {
    enable = lib.mkEnableOption "Enable openssh server";
    banner = extras.options.mkEnabledOption "Enable ssh banner";
  };
  config.services.openssh = {
    enable = cfg.enable;
    settings.Banner = lib.mkIf cfg.banner "${banner}";

    settings.StreamLocalBindUnlink = "yes";
  };
}
