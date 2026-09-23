{
  config,
  extras,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.landscape;

  col = {
    reset = ''\033[0m'';
    bold = ''\033[1m'';
    green = ''\033[32m'';
    yellow = ''\033[33m'';
    red = ''\033[31m'';
  };

  formatBytes = ''
    function format_bytes(bytes,   units, i) {
      split("B KB MB GB TB PB", units)
      i = 1
      while (bytes >= 1024 && i < 6) { bytes /= 1024; i++ }
      return sprintf("%.1f%s", bytes, units[i])
    }
  '';

  makeBar = with col; ''
    function make_bar(used, total, width, prec, color, fill_len, fill, pad_len, pad) {
      if (total <= 0) return sprintf("%*s", width, "")
      prec = used / total
      
      # Color red for high percentages
      if (prec > 0.85) color = "${red}"
      else if (prec > 0.70) color = "${yellow}"
      else color = "${green}"

      fill_len = int(width * prec)
      fill = ""
      if (fill_len > 0) {
        fill = sprintf("%*s", fill_len, ">")
        gsub(/ /, "=", fill)

        if (prec >= 1.0) sub(/>/, "=", fill)
      }

      pad_len = width - length(fill)
      pad = (pad_len > 0) ? sprintf("%*s", pad_len, "") : ""

      return color fill "${reset}" pad
    }
  '';

  logo = pkgs.writeShellApplication {
    name = "logo";
    runtimeInputs = with pkgs; [
      coreutils
      figlet
      lolcat
    ];
    text = with col; ''
      uname -n | figlet -f slant | lolcat -t -F 0.3 -f
      echo -e "Up for ${bold}$(${pkgs.procps}/bin/uptime -p | tail -c+4)${reset}"
    '';
  };

  filesystems = pkgs.writeShellApplication {
    name = "filesystems";
    runtimeInputs = with pkgs; [
      util-linux
      coreutils
      gawk
    ];
    text = with col; ''
      df \
        --local \
        --exclude-type=tmpfs \
        --exclude-type=devtmpfs \
        --exclude-type=efivarfs \
        --exclude-type=overlay \
        --output=source,fstype,used,size,target |
        tail -n+2 | sort -rnk4 | awk '
        ${formatBytes}
        ${makeBar}

        BEGIN {
          print " ${bold}Device${reset}| ${bold} Mount${reset}| ${bold}  Used${reset}|| ${bold} Size ${reset}"
        }

        {
          source=$1;
          target=$5;

          used=$3*1024;
          size=$4*1024;

          bar = make_bar(used,size,20)

          printf("%s| %s| %7s|[%s]|%s\n", source, target, format_bytes(used), bar, format_bytes(size));
      }' | column -s '|' -t --color -o ' '
    '';
  };

  memory = pkgs.writeShellApplication {
    name = "memory";
    runtimeInputs = with pkgs; [
      util-linux
      gawk
    ];
    text = with col; ''
      free -b | awk '
        ${formatBytes}
        ${makeBar}

        /^Mem:/ || /^Swap:/ {
          type=$1; sub(/:/, "", type);
          total=$2; used=$3;

          bar = make_bar(used,total,20)
          printf("${bold}%s${reset}|%7s [%s]|%s\n", type , format_bytes(used), bar, format_bytes(total));
      }' | column -s '|' -t --color -o ' '
    '';
  };

  selfcheck = pkgs.writeShellApplication {
    name = "selfcheck";
    runtimeInputs = with pkgs; [
      config.systemd.package
      coreutils
      gawk
    ];
    text = with col; ''
      services () {
        count=$(systemctl list-units --failed --no-legend --plain | wc -l)

        if (( count != 0 )); then
          echo -e "${red}$count failed services ${reset}"
          SYSTEMD_COLORS=1 systemctl list-units --failed --no-legend
        else
          echo -e "${green}No failed services${reset}"
        fi
      }

      filesystems () {
        echo -en "${red}"
        df \
          --local \
          --exclude-type=tmpfs \
          --exclude-type=devtmpfs \
          --exclude-type=efivarfs \
          --exclude-type=overlay \
          --output=target,used,size |
        awk '
          NR>1 && $3>0 && ($2/$3 > 0.8) {
            printf("Filesystem on %s is %.1f%% full!\n", $1, ($2/$3)*100);
          }
        ';
        echo -en "${reset}"
      }

      services
      filesystems
    '';
  };

  widgets =
    lib.optional cfg.components.logo (lib.getExe logo)
    ++ lib.optional cfg.components.filesystem (lib.getExe filesystems)
    ++ lib.optional cfg.components.memory (lib.getExe memory)
    ++ lib.optional cfg.components.selfcheck (lib.getExe selfcheck);

  inner = pkgs.writeShellScript "landscape-inner" ''
    cat ${builtins.concatStringsSep " <(echo) " (map (p: "<(${p})") widgets)}
  '';

  landscape = pkgs.writeShellApplication {
    name = "landscape";
    runtimeInputs = with pkgs; [
      coreutils
    ];
    text = ''
      if ! timeout ${builtins.toString cfg.timeout} ${inner}; then
        echo -e '\033[31mGenerating landscape took more than ${builtins.toString cfg.timeout} seconds, Aborting!\033[0m';
      fi

      exit 0;
    '';
  };

in
{
  options.landscape =
    with lib;
    with extras.options;
    {
      enable = lib.mkEnableOption "Enable login landscape";
      login = mkEnabledOption "Enable landscape for local terminal";
      sshd = mkEnabledOption "Enable landscape for ssh logins";
      timeout = lib.mkOption {
        description = "How many seconds to wait for the landscape to generate before forcefully terminating it to prevent lockout.";
        type = lib.types.ints.unsigned;
        default = 2;
        example = 5;
      };
      components = {
        logo = mkEnabledOption "Enable landscape logo";
        filesystem = mkEnabledOption "Enable landscape filesystem overview";
        memory = mkEnabledOption "Enable landscape memory usage";
        selfcheck = mkEnabledOption "Enable landscape selfcheck";
      };
    };

  config = lib.mkIf cfg.enable {
    security.pam.services.login.text = lib.mkIf cfg.login (
      lib.mkDefault (
        lib.mkAfter ''
          session optional pam_exec.so stdout ${lib.getExe landscape}
        ''
      )
    );

    security.pam.services.sshd.text = lib.mkIf cfg.sshd (
      lib.mkDefault (
        lib.mkAfter ''
          session optional pam_exec.so stdout ${lib.getExe landscape}
        ''
      )
    );
  };
}
