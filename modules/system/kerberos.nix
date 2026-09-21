{ config, extras, lib, ... }: let
  cfg = config.ludd.krb;
in
{
  options.ludd.krb = {
    enable = lib.mkEnableOption "Enable and configure kerberos for /LUDD/";
    kcm = extras.options.mkEnabledOption "Configure kerberos to use Kerberos Cache Manager.";
  };
  config = lib.mkIf cfg.enable {
    security.krb5.enable = true;

    services.sssd.kcm = cfg.kcm;
    security.krb5.settings = {
      appdefaults = {
        ticket_lifetime = "1d";
        renew_lifetime = "14d";
      };

      libdefaults = {
        default_realm = "LUDD.LTU.SE";
        allow_weak_crypto = true;
        kdc_timesync = "1";
        forwardable = true;
        dns_lookup_realm = true;
        dns_lookup_kdc = true;
        rdns = false;
      };

      realms = {
        "LUDD.LTU.SE" = {
          kdc = [
            "infra01.dh3.ludd.ltu.se"
            "infra03.dh3.ludd.ltu.se"
            "infra02.dh3.ludd.ltu.se"
          ];
          admin_server = "infra01.dh3.ludd.ltu.se";
          master_kdc = "infra01.dh3.ludd.ltu.se";
          default_domain = "ludd.ltu.se";
        };
      };

      domain_realms = {
        ".ludd.ltu.se" = "LUDD.LTU.SE";
        "ludd.ltu.se" = "LUDD.LTU.SE";
      };
    };
  };
}
