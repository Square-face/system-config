{ lib, ... }: let
  port = 8989;
in {
  services.sonarr = {
    enable = true;
    user = "sonarr";
    group = "media";

    settings = {
      app.instancename = "Sonarr - Shitv";
      auth.enabled = false;

      server = {
        inherit port;
        urlbase = "";
        bindaddress = "[::1]";
      };
    };
  };

  services.nginx.virtualHosts."sonarr.shit" = {
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
