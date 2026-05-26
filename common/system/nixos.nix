{lib, ...}: {
  nix.settings = {
    use-xdg-base-directories = lib.mkDefault true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  systemd.services.nix-daemon.serviceConfig.CPUWeight = 80;
}
