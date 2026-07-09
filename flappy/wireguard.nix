{ config, ... }: {
  networking.wg-quick.interfaces = {
    shitcloud = {
      privateKeyFile = config.age.secrets.wg-shitcloud.path;

      address = [ "10.2.100.4/32" ];
      peers = [
        {
          publicKey = "1XaNV7e/cxm5hRAbLj+/MP/R9oO82aUTL27yb1eeFyU=";
          allowedIPs = [ "10.2.0.0/16" ];
          endpoint = "130.240.204.10:51821";
        }
      ];
    };
  };
}
