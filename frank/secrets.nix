{ ... }: {
  age.secrets.wg-shitcloud = {
    file = ../secrets/frank/wg_shitcloud.age;
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };
}
