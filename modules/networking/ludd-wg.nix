{
  config,
  vars,
  lib,
  ...
}:
let
  cfg = config.ludd.vpn;
in
{
  options.ludd.vpn = {
    enable = lib.mkEnableOption "Enable /LUDD/ Wireguard VPN";
    ip = lib.mkOption {
      description = "This devices ip address";
      type = lib.types.str;
      example = "192.168.100.67";
    };
    dns = lib.mkOption {
      description = "Use ludd dns server for .ludd.ltu.se (also enables the dns module)";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    dns.enable = cfg.dns;

    networking.wg-quick.interfaces = {
      ludd = {
        privateKeyFile = config.age.secrets.wg-ludd.path;

        address = [ "${cfg.ip}/32" ];
        peers = [
          {
            publicKey = "CkHERo9J8Kz4UxtZRXx3JhQpb8jfxeqBxdbkMGp3piE=";
            allowedIPs = [
              "10.30.0.0/16"
              "10.10.0.0/16"
              "172.30.0.0/16"
              "172.19.0.0/16"
              "130.240.202.0/24"
            ];
            endpoint = "130.240.22.206:51820";
          }
        ];

        postUp = lib.mkIf cfg.dns (config.dns.addServer "ludd.ltu.se" "10.30.0.1");
        postDown = lib.mkIf cfg.dns (config.dns.delServer "ludd.ltu.se" "10.30.0.1");
      };
    };
  };
}
