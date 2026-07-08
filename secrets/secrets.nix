let
  shrexbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINumxEFYPrJiPRtOE/e68i7zTKp6iSEnGaCPOlhiiwFQ";
  frank = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQzlCk3x3PuZXrl8K2kCsH/ls7PFfrWf6kIlie2Gzab";

  systems = [
    shrexbox
    frank
  ];
in
{
  # "wg_ludd-shrexbox.age".publicKeys = shrexbox;

  "wg_shitcloud-shrexbox.age".publicKeys = [ shrexbox ];
  # "wg_shitcloud-frank.age".publicKeys = shrexbox;
}
