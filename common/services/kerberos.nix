{ lib, ... }: {
  security.krb5.enable = lib.mkDefault true;
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
}
