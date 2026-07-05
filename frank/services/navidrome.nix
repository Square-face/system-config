{ pkgs, ... }: let
  socket = "unix:/run/navidrome/navidrome.sock";
in {
  services.navidrome.enable = true;
  services.navidrome.group = "nginx";
  services.navidrome.plugins = with pkgs.navidromePlugins; [
    audiomuseai
  ];
  services.navidrome.settings = {
    Address = socket;
    BaseUrl = "https://music.sq8.dev";

    DataFolder = "/var/lib/navidrome/data";
    CacheFolder = "/var/lib/navidrome/cache";
    MusicFolder = "/srv/music";

    Agents = "audiomuseai,listenbrainz";
    AlbumPlayCountMode = "normalized";
    MPVPath = "${pkgs.mpv}";

    Scanner.PurgeMissing = "always";

    Subsonic = {
      ArtistParticipations = true;
    };

    TranscodingCacheSize = "1GB";

    Prometheus = {
        Enabled = true;
    };
  };

  services.nginx.virtualHosts."music.sq8.dev" = {
      locations."/".proxyPass = "http://${socket}";
  };
}
