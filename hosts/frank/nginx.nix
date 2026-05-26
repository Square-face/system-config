{...}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."home.lan" = {
      extraConfig = ''
        allow 10.0.0.0/24;
        allow 10.2.100.0/24;
        deny all;
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://[::1]:8123";
        proxyWebsockets = true;
      };
    };

    virtualHosts."sq8.dev" = {
      forceSSL = false;
      enableACME = false;
      locations."/".root = "/var/lib/nginx/www";
    };

    gitweb = {
      enable = true;
      location = "";
      virtualHost = "git.sq8.dev";
    };
  };
  services.gitweb.projectroot = "/var/git";
}
