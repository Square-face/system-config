{...}: {
  users.groups.media = {};

  systemd.targets."servarr".wantedBy = [ "multi-user.target" ];

  imports = [
    ./tdarr.nix
    ./qbittorrent.nix

    ./sonarr.nix
    ./radarr.nix
    ./prowlarr.nix
  ];
}
