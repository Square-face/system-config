{ lib, ... }: let
  port = 7878;
in {
  services.radarr = {
    enable = true;
    user = "radarr";
    group = "media";

    settings = {
      app.instancename = "Radarr - Shitv";
      auth.enabled = false;

      server = {
        inherit port;
        urlbase = "";
        bindaddress = "[::1]";
      };
    };
  };

  services.nginx.virtualHosts."radarr.shit" = {
    locations."/".proxyPass = "http://[::1]:${builtins.toString port}";
  };

  systemd.services.sonarr = {
    wantedBy = lib.mkForce [ "servarr.target" ];

    # Kill sonarr if any mounts disapear
    bindsTo = [
      "mnt-media-legacy.mount"
      "mnt-bulk.mount"
      "mnt-merged-legacy.mount"
    ];
  };
}
