{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.rootbash;
in
{
  options.rootbash = {
    enable = lib.mkEnableOption "Enable rootbash";
    color = lib.mkOption {
      description = "Color for the shell when running as root";
      type = lib.types.str;
      example = ''\e[38;5;226m\'';
    };
  };
  config = lib.mkIf cfg.enable {
    programs.bash.promptInit = with cfg; ''
      PS1="\[${color}]\u\[\e[38;5;7m\]@\[${color}]\h \[\e[38;5;33m\]\w \[\033[0m\]$ "
    '';
  };
}
