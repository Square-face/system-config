{ lib, ... }: {
  services.openssh = {
    enable = lib.mkDefault true;
    banner = "Tagga fejden";
  };
}
