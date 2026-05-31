{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.rootbash.enable = lib.mkOption {
    description = "Enable rootbash";
    type = lib.types.bool;
    default = true;
  };
  options.rootbash.color = lib.mkOption {
    description = "Color for the shell when running as root";
    type = lib.types.str;
  };
  config =
    let
      enabled = config.rootbash.enable;
      color = config.rootbash.color;
    in
    lib.mkIf enabled {
      programs.bash.promptInit = ''
        PS1="\[${color}]\u\[\e[38;5;7m\]@\[${color}]\h \[\e[38;5;33m\]\w \[\033[0m\]$ "
      '';
      programs.bash.interactiveShellInit = ''
        load=$(cat /proc/loadavg | awk '{print $1}')
        procs=$(ps -e | wc -l)

        ram=$(free -h | grep Mem | awk '{print $3 " / " $2}')
        swap=$(free -h | grep Swap | awk '{print $3 " / " $2}')

        uptime=$(uptime | awk '{
          if ($4 ~ /days|day/) {  # Uptime is 1+ days
            days = $3;
            time = substr($5, 1, length($5)-1);
            split(time, t, ":"); hours = t[1]; mins = t[2];
            printf "%sd %sh %smin", days, hours, mins;
          } else {  # Uptime is < 1 day (hours:minutes)
            time = substr($3, 1, length($3)-1);
            split(time, t, ":"); hours = t[1]; mins = t[2];
            printf "%sh %smin", hours, mins;
          }
        }')
        loggedin=$(who | wc -l)

        line0=$(printf "                    Up for %-15s     %3s logged in\n" "$uptime" $loggedin)
        line1=$(printf "                    Load: %11s      Processes: %6s  \n" $load $procs)
        line2=$(printf "                    Ram: %12s      Swap: %11s  \n" "$ram" "$swap")

        echo -e "$line0"
        hostname | sed 's/\b./\u&/g' | ${pkgs.figlet}/bin/figlet -c -f slant | ${pkgs.lolcat}/bin/lolcat -t -F 0.3
        echo -e "$line1\n$line2"
      '';
    };
}
