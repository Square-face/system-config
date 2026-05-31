{ ... }:
{
  networking.hostName = "frank";
  networking.useNetworkd = true;

  networking.nameservers = [ "127.0.0.1" ];

  networking.interfaces.eno1.useDHCP = false;

  networking.bridges.br0.interfaces = [ "eno1" ];
  networking.nat = {
    enable = true;
    externalInterface = "enp0s20f0u2";
    internalInterfaces = [ "br0" ];
    internalIPs = [ "10.0.0.0/24" ];
  };

  networking.interfaces.br0.useDHCP = false;
  networking.interfaces.br0.ipv4 = {
    addresses = [
      {
        address = "10.0.0.1";
        prefixLength = 24;
      }
    ];
  };

  networking.interfaces.enp0s20f0u2 = {
    useDHCP = true;
    tempAddress = "disabled";
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
  };
  networking.firewall.enable = false;
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.2.2.1/16" ];
    privateKeyFile = "/etc/nixos/secrets/wg0-priv";
    peers = [
      {
        publicKey = "1XaNV7e/cxm5hRAbLj+/MP/R9oO82aUTL27yb1eeFyU=";
        allowedIPs = [ "10.2.0.0/16" ];
        endpoint = "130.240.204.10:51821";
        persistentKeepalive = 20;
      }
    ];
  };
}
