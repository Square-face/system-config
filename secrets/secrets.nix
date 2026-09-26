let
  shrexbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4Zq8tIImKe0e5EYzkU9SIRAbb+vxNptyANBD22Gsa7";
  flappy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFr5py9dTV8gQQx7QGgorWIXeaQZn0+nvSQBs+i+qKWy";

  frank = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQzlCk3x3PuZXrl8K2kCsH/ls7PFfrWf6kIlie2Gzab";
  markus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN15NvKR2q13j7sIPSL/v9NVNcs5ZEsc+JNI2bcqX3BW";
  shitbix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSKWYh1RvdzsManU5/85lTF6ZTrq/0rrDj3lWjGxvYc";

  systems = [
    # Desktops/Laptops
    shrexbox
    flappy

    # Servers
    frank
    markus
    shitbix
  ];
in
{
  # Shitcloud vpn secret keys
  "flappy/wg_shitcloud.age".publicKeys = [ flappy ];
  "shrexbox/wg_shitcloud.age".publicKeys = [ shrexbox ];

  "frank/wg_shitcloud.age".publicKeys = [ frank ];
  "markus/wg_shitcloud.age".publicKeys = [ markus ];
  "shitbix/wg_shitcloud.age".publicKeys = [ shitbix ];

  # /LUDD/ vpn secret keys
  "flappy/wg_ludd.age".publicKeys = [ flappy ];
  "shrexbox/wg_ludd.age".publicKeys = [ shrexbox ];

  # Passwords
  "password-sq8.age".publicKeys = systems;
  "password-quisita.age".publicKeys = systems;
  "password-secoffee.age".publicKeys = systems;
}
