{...}: {
  imports = [
    ./servarr

    ./borg.nix
    ./scrub.nix
    ./nginx.nix
    ./traefik.nix
  ];
}
