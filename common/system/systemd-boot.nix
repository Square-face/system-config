{lib, ...}: {
  boot.loader.systemd-boot = {
    enable = lib.mkDefault true;

    editor = lib.mkDefault false; # Recomended to be false as per the docs
    memtest86.enable = lib.mkDefault true;
  };
}
