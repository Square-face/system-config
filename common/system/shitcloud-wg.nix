{ config, vars, lib, ... }: let
  cfg = config.wg.shitcloud;
in {
  options.wg.shitcloud = {
    enable = lib.mkEnableOption "Enable Shitcloud Wireguard VPN";
    ip = lib.mkOption {
      description = "This devices ip address";
      type = lib.types.str;
      example = "192.168.100.67";
    };
    dns = lib.mkOption {
      description = "Add shitcloud to dns for .shit domains (also enables the dns module)";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces = {
      shitcloud = {
        privateKeyFile = config.age.secrets.wg-shitcloud.path;

        address = [ "${cfg.ip}/32" ];
        peers = [
          {
            publicKey = "1XaNV7e/cxm5hRAbLj+/MP/R9oO82aUTL27yb1eeFyU=";
            allowedIPs = [ "10.2.0.0/16" ];
            endpoint = "130.240.204.10:51821";
          }
        ];
      };
    };

    dns.enable = true;
    dns.extraServers = lib.mkIf cfg.dns [
      "/shit/10.2.0.1"
    ];
  };
}
