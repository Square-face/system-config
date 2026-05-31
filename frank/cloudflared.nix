{ ... }:
{
  services.cloudflared.enable = true;
  services.cloudflared.tunnels."sq8.dev" = {
    credentialsFile = "/etc/nixos/secrets/cloudflared-creds.json";
    certificateFile = "/etc/nixos/secrets/cloudflared-cert.pem";
    default = "http_status:404";
    ingress = {
      "sq8.dev".service = "http://[::1]:80";
      "*.sq8.dev".service = "http://[::1]:80";
    };
  };
}
