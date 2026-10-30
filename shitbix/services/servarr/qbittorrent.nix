{config, lib, ...}: let
  port = 8181;
in {
  services.qbittorrent = {
    user = "qbittorrent";
    group = "media";
  };

  services.qbittorrent.enable = true;
  services.qbittorrent.webuiPort = port;
  services.qbittorrent.torrentingPort = 8694;

  services.nginx.virtualHosts."tor.shit" = {
    locations."/".proxyPass = "http://127.0.0.1:${builtins.toString port}";
  };

  systemd.services.qbittorrent.bindsTo = [ "mnt-bulk.mount" ];
}
