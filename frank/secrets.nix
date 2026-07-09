{ ... }: {
  age.secrets.wg-shitcloud = {
      file = ../secrets/wg_shitcloud-frank.age;
      mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };
}
