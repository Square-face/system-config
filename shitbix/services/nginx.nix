{ pkgs, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    defaultListen = [
      { addr = "10.2.1.1"; }
    ];
  };
}
