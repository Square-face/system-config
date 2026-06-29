{ ... }:
{
  users.groups.markus = { };
  users.users.markus.createHome = false;

  services.borgbackup.repos.markus = {
    user = "markus";
    group = "markus";
    path = "/srv/backups/markus";
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3tF83FQRO49zboVYsUzibe5G+on0WNNe9KEl9Yzfgm"
    ];
  };
}
