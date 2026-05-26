{ lib, ... }: {
  virtualisation.podman = {
    enable = lib.mkDefault true;

    dockerCompat = lib.mkDefault true;

    dockerSocket.enable = lib.mkDefault true;
    autoPrune.enable = lib.mkDefault true;
  };
}
