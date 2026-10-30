{ pkgs, lib, ... }: {

  unfree.enable = true;
  unfree.allowed = ["tdarr-node" "tdarr-server"];

  users.users.tdarr.uid = 1102;
  users.groups.media.gid = 1100;

  services.tdarr.group = "media";
  services.tdarr.user = "tdarr";

  systemd.tmpfiles.rules = [
    "d /var/lib/tdarr/cache 0740 tdarr media -"
  ];

  services.tdarr.server = {
    enable = true;
    serverIP = "127.0.0.1";
    serverBindIP = true;
    auth.enable = false;
  };

  services.nginx.virtualHosts."tdarr.shit" = {
    locations."/".proxyPass = "http://127.0.0.1:8265";
  };

  systemd.services.tdarr-node-cpu.bindsTo = [ "mnt-media-legacy.mount" "mnt-bulk.mount" ];
  systemd.services.tdarr-node-cpu.serviceConfig.ReadWritePaths = [
    "/var/lib/tdarr/cache"
    "/mnt/media/legacy"
    "/mnt/bulk/staging/legacy"
  ];
  services.tdarr.nodes.cpu = {
    enable = true;
    startPaused = true;
    serverURL = "http://127.0.0.1:8266";
    #environmentFile = "/etc/nixos/secrets/tdarr-node";
    #pathTranslators = [
    #  {server = "/app/server"; node = "/opt/services/media/tdarr/server";}
    #  {server = "/app/configs"; node = "/opt/services/media/tdarr/configs";}
    #  {server = "/app/logs"; node = "/opt/services/media/tdarr/logs";}
    #  {server = "/temp"; node = "/opt/services/media/tdarr/cache";}
    #  {server = "/unprocessed"; node = "/mnt/bulk/staging";}
    #  {server = "/processed"; node = "/mnt/media";}
    #];
    workers = {
      healthcheckCPU = 1;
      healthcheckGPU = 0;
      transcodeCPU = 1;
      transcodeGPU = 0;
    };
  };
}
