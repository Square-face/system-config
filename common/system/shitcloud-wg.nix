{ config, vars, lib, ... }: let
  cfg = config.shitcloud.vpn;
in {
  options.shitcloud.vpn = {
    enable = lib.mkEnableOption "Enable Shitcloud Wireguard VPN";
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

        address = [ "${vars.shitcloud.wg.ip}/32" ];
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
