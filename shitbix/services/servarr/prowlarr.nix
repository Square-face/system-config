{ lib, ... }: let
  port = 9696;
in {
  services.prowlarr = {
    enable = true;

    settings = {
      app.instancename = "Prowlarr - Shitv";
      auth.enabled = false;

      server = {
        inherit port;
        urlbase = "";
        bindaddress = "[::1]";
      };
    };
  };

  services.nginx.virtualHosts."prowlarr.shit" = {
    locations."/".proxyPass = "http://[::1]:${builtins.toString port}";
  };

  systemd.services.sonarr = {
    wantedBy = lib.mkForce [ "servarr.target" ];

    # Kill sonarr if any mounts disapear
    bindsTo = [
      "mnt-merged-legacy.mount"
      "mnt-media-legacy.mount"
      "mnt-bulk.mount"
    ];
  };
}
