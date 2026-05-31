{ ... }:
{
  services.home-assistant = {
    enable = true;
    extraPackages = ps: with ps; [ psycopg2 ];
    extraComponents = [
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      "isal"

      "sonos"
      "smlight"
      "unifiprotect"

      "thread"
      "homeassistant_hardware"
    ];
    config = {
      homeassistant = {
        name = "sqHome";
      };
      default_config = { };
      recorder.db_url = "postgresql://@/hass";
      http = {
        server_host = "::1";
        use_x_forwarded_for = true;
        trusted_proxies = [ "::1" ];
      };
    };
  };

  services.matter-server.enable = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "hass" ];
    ensureUsers = [
      {
        name = "hass";
        ensureDBOwnership = true;
      }
    ];
  };
}
