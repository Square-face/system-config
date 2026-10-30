{ config, ... }: {
  services.traefik.enable = true;
  services.traefik.group = "docker";
  services.traefik.staticConfigOptions = {
    providers.docker = {
      exposedByDefault = false;
      network = "proxy";
      defaultRule = let
        default_domain = "shitcloud.se";
        name = "{{ if .Labels.friendly_name }}{{ .Labels.friendly_name }}{{ else }}{{ .ContainerName }}{{ end }}";
        group_domain = "{{ if .Labels.group_domain }}.{{ .Labels.group_domain }}{{ end }}";
        domain = "{{ if .Labels.domain }}.{{ .Labels.domain }}{{ else }}.${default_domain}{{ end }}";

      in "Host(`${name}${group_domain}${domain}`)";
    };
    api.dashboard = true;
    api.insecure = true;

    log.level = "INFO";
    accesslog = false;

    metrics.prometheus = true;
    entrypoints.metrics.address = "127.0.0.1:8082";
    entrypoints.traefik.address = "127.0.0.1:8079";

    certificatesresolvers.le.acme = {
      email = "linus@sq8.dev";
      storage = "acme.json";
      httpchallenge.entrypoint = "web";
    };

    entrypoints.websecure = {
      http3 = true;
      address = "10.0.0.241:443";
      http.tls.certresolver = "le";
    };
    entrypoints.web = {
      address = "10.0.0.241:80";
      http.redirections.entryPoint = {
        to = "websecure";
        scheme = "https";
        permanent = true;
      };
    };
  };
}
