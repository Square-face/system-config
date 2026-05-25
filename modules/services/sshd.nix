{ lib, pkgs, ... }: let
  banner = pkgs.writeText "banner" "Tagga fejden";
in {
  services.openssh = {
    enable = lib.mkDefault true;
    settings.Banner = "${banner}";
    settings.StreamLocalBindUnlink = "yes";
  };
}
