# Nixos system configuration

System configuration for my 3 primary devices (server, laptop and desktop). Each device gets its own directory in repository root, which contain device specific options, including services with options that only apply to that device. `common` containts modules that are generic and can be used by multiple devices.

All modules are configured to be on by default if imported, i.e the sshd module sets `services.openssh.enable` to `lib.mkDefault true`.
