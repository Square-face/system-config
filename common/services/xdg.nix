{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = "*";
      niri.default = [
        "gnome"
        "gtk"
      ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome # Required for Niri screencasting
      xdg-desktop-portal-gtk # Required for file choosers
    ];
  };
}
