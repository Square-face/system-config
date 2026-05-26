{ ... }: {
  users.groups.markus = {};
  users.users.markus = {
    createHome = false;
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3tF83FQRO49zboVYsUzibe5G+on0WNNe9KEl9Yzfgm" ];
  };

  services.borgbackup.repos.markus = {
    user = "markus";
    group = "markus";
    path = "/mnt/backups/markus";
    authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3tF83FQRO49zboVYsUzibe5G+on0WNNe9KEl9Yzfgm"];
  };
}
