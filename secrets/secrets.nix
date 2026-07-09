let
  shrexbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINumxEFYPrJiPRtOE/e68i7zTKp6iSEnGaCPOlhiiwFQ";
  flappy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFr5py9dTV8gQQx7QGgorWIXeaQZn0+nvSQBs+i+qKWy";
  frank = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQzlCk3x3PuZXrl8K2kCsH/ls7PFfrWf6kIlie2Gzab";

  systems = [
    shrexbox
    frank
  ];
in
{
  # Shitcloud vpn profiles
  "wg_shitcloud-shrexbox.age".publicKeys = [ shrexbox ];
  "wg_shitcloud-flappy.age".publicKeys = [ flappy ];
  "wg_shitcloud-frank.age".publicKeys = [ frank ];
}
