{ ... }: {
  networking.hostName = "shitbix";

  networking.firewall.enable = false;

  networking.useNetworkd = true;
  systemd.network.enable = true;

  dns.enable = true;
  dns.DoH = false;

  networking.useDHCP = false;
  networking.hosts."10.2.1.1" = ["repo.ultr4.dev"];

  wg.shitcloud = {
    enable = true;
    ip = "10.2.1.1";
  };

  systemd.network.netdevs = {
    "10-vlan0" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan0";
      };
      vlanConfig.Id = 4;
    };
  };

  systemd.network.networks = {
    # Physical Interface
    "10-eno1" = {
      matchConfig.Name = "eno1";
      vlan = [ "vlan0" ]; # Attaches vlan0 to this interface
      address = [ "10.0.0.241/24" ];
      networkConfig.LinkLocalAddressing = "no"; # Optional: Disable IPv6 link-local if entirely unused
      linkConfig.RequiredForOnline = "carrier";
    };

    # VLAN Interface
    "20-vlan0" = {
      matchConfig.Name = "vlan0";
      address = [ "10.0.3.241/24" ];
      routes = [
        { Gateway = "10.0.3.1"; }
      ];
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
