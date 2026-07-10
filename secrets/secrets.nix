let
  shrexbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4Zq8tIImKe0e5EYzkU9SIRAbb+vxNptyANBD22Gsa7";
  flappy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFr5py9dTV8gQQx7QGgorWIXeaQZn0+nvSQBs+i+qKWy";
  frank = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQzlCk3x3PuZXrl8K2kCsH/ls7PFfrWf6kIlie2Gzab";

  systems = [
    shrexbox
    flappy
    frank
  ];
in
{
  # Shitcloud vpn profiles
  "shrexbox/wg_shitcloud.age".publicKeys = [ shrexbox ];
  "flappy/wg_shitcloud.age".publicKeys = [ flappy ];
  "frank/wg_shitcloud.age".publicKeys = [ frank ];

  "password-sq8.age".publicKeys = systems;
}
