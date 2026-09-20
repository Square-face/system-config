{ ... }: {
  imports = [
    ./unfree.nix

    ./users/default.nix
    ./system/default.nix
    ./services/default.nix
  ];
}
