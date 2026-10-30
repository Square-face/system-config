{ ... }: {
  age.secrets.wg-shitcloud = {
    file = ../secrets/shitbix/wg_shitcloud.age;
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };
}
