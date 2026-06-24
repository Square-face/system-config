{ pkgs, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts."sq8.dev" = {
      locations."/".root = "/var/lib/nginx/www";
    };

    virtualHosts."static.sq8.dev" = {
      locations."/".root = "/var/lib/nginx/static";
    };

    virtualHosts."home.lan" = {
      extraConfig = ''
        allow 10.0.0.0/24;
        allow 10.2.100.0/24;
        allow fd00:1234:5678::/64;
        deny all;
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://[::1]:8123";
        proxyWebsockets = true;
      };
    };

    virtualHosts."git.sq8.dev".extraConfig = "access_log /var/log/nginx/git/access.log;";
  };

  services.cgit.sq8 = {
    enable = true;
    user = "sq8";
    group = "sq8";
    scanPath = "/var/git/sq8";
    gitHttpBackend.enable = true;
    gitHttpBackend.checkExportOkFiles = false;
    nginx.virtualHost = "git.sq8.dev";
    settings = {
      enable-blame = 1;
      enable-git-config = 1;
      enable-commit-graph = 1;
      clone-url = "https://git.sq8.dev/$CGIT_REPO_URL";
      about-filter = "${pkgs.cgit}/lib/cgit/filters/about-formatting.sh";
      readme = [
        "main:README.md"
        "main:readme.md"
        "main:README"
        "main:readme"
      ];
    };
  };
}
