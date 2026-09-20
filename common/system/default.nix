{ ... }: {
  imports = [
    ./obs.nix
    ./dns.nix
    ./kde.nix
    ./shitcloud-wg.nix
    ./ludd-wg.nix
  ];
}
