{
  config,
  extras,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.alloy;

  tab = str: lib.trim (lib.replaceString "\n" "\n  " str);

  # Option types and functions
  opts = let
    extraConfig = lib.mkOption {
      description = "Extra text to add to block";
      type = lib.types.str;
      default = "";
    };

    forward_to = lib.mkOption {
      description = "List of receivers to send metrics to.";
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    relabel_rules = lib.mkOption {
      description = "Relabel rules to apply before forwarding";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    kind = lib.mkOption {
      description = "Block subtype";
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "unix";
    };

    mkAttrOption = opt: desc: lib.mkOption {
      description = desc;
      type = lib.types.attrsOf opt;
      default = {};
    };

    blockConfig = options: lib.types.submodule (
      { name, ... }: {
        freeformType = lib.types.attrsOf lib.types.anything;
        options = options // { inherit extraConfig; };
      }
    );
  in {
    inherit mkAttrOption blockConfig;
    prom = {
      remote_write = blockConfig {
        endpoint.url = lib.mkOption {
          description = "Url endpoint to write to";
          type = lib.types.str;
          example = "http://10.0.0.1:9090/api/v1/write";
        };
      };
      exporter = blockConfig { inherit kind; };

      scrape = blockConfig {
        inherit forward_to;

        scrape_interval = lib.mkOption {
          description = "How frequently to scrape the targets of this scrape configuration.";
          type = lib.types.str;
          default = "60s";
        };

        scrape_timeout = lib.mkOption {
          description = "The timeout for scraping targets of this configuration.";
          type = lib.types.str;
          default = "10s";
        };

        targets = lib.mkOption {
          description = "List of targets to scrape.";
          type = with lib.types; listOf (oneOf [(listOf attrs) str]);
        };
      };
    };

    loki = {
      write = blockConfig {
        inherit;

        endpoint.url = lib.mkOption {
          description = "Url endpoint to write to";
          type = lib.types.str;
          example = "http://10.0.0.1:3100/loki/api/v1/push";
        };
      };

      source = blockConfig { inherit kind forward_to relabel_rules; };
      relabel = blockConfig { inherit forward_to; };
    };
  };

  renderers = rec {
    special = let
      raw_strings = v: if builtins.isString v then {__expr = v;} else v;
    in {
      relabel_rules = raw_strings;
      forward_to = value: formatters.array (map raw_strings value);
      targets = value: formatters.concat (map raw_strings value);
    };

    not_blocks = ["labels"];

    formatters = {
      list = items: lib.concatStrings (map (v: "\n  ${val v},") items);
      array = items: "[${formatters.list items}\n]";
      concat = items: "array.concat(${formatters.list items}\n)";
    };

    argsSuffix = sep: attr: lib.concatStrings (map ({name, value}: "\n  ${name} = ${namedVal name value}${sep}") (lib.attrsToList attr));
    args = argsSuffix "";

    attrset = value: let

      attrs = lib.filterAttrs (name: v: name != "extraConfig" && v != null) value;
      argAttrs = lib.filterAttrs (name: v: (!builtins.isAttrs v) || (builtins.elem name not_blocks)) attrs;

      blocks = lib.mapAttrsToList
        (name: value: ''
          ${name} {
            ${tab (attrset value)}
          }'')
        (lib.filterAttrs (n: val: (builtins.isAttrs val) && (!builtins.elem n not_blocks)) attrs);
      in ''
        ${args argAttrs}
        ${builtins.concatStringsSep "\n" blocks}
        ${value.extraConfig or ""}
      '';

    val = value:
      if (builtins.isAttrs value && value ? __expr) then
        value.__expr
      else if (builtins.isString value) then
        ''"${value}"''
      else if (builtins.isInt value) then
        "${builtins.toString value}"
      else if (builtins.isList value) then
        formatters.array value
      else if (builtins.isAttrs value) then
        ''{
        ${tab (argsSuffix "," value)}
        }''
      else
        throw "Got a value ${builtins.toString value} with type ${builtins.typeOf value} which is not allowed.";

    namedVal = name: value: (lib.findFirst
      (v: v.name == name)
      { value = val; }
      (lib.attrsToList special)).value
        value;

    block =
      base_path: attr: builtins.concatStringsSep "\n"
        (lib.mapAttrsToList
          (label: value: let
            path = if (value ? kind) then "${base_path}.${value.kind}" else base_path;
            attrs = lib.filterAttrs (name: v: name != "kind") value;
          in ''
            ${path} "${label}" {
              ${tab (attrset attrs)}
            }'') attr);
  };
in
{
  options.alloy = with lib; with extras.options; {
    enable = mkEnableOption "Enable alloy module.";

    prometheus = with opts.prom; with opts; {
      scrape = mkAttrOption scrape "Prometheus targets, categorized by interval";
      exporter = mkAttrOption exporter "Prometheus exporters";
      remote_write = mkAttrOption remote_write "Prometheus remote write targets";
    };

    loki = with opts.loki; with opts;{
      write = mkAttrOption write "Loki write targets";
      source = mkAttrOption source "Loki log sources";
      relabel = mkAttrOption relabel "Loki relabel rules";
    };
  };

  config = lib.mkIf cfg.enable {
    services.alloy.enable = true;

    # Write to files
    environment.etc."alloy/config.alloy".text = builtins.concatStringsSep "\n" (with renderers; [
      (''
        logging { level = "warn" }
      '')

      (block "prometheus.exporter" cfg.prometheus.exporter)
      (block "prometheus.scrape" cfg.prometheus.scrape)
      (block "prometheus.remote_write" cfg.prometheus.remote_write)

      (block "loki.source" cfg.loki.source)
      (block "loki.relabel" cfg.loki.relabel)
      (block "loki.write" cfg.loki.write)
    ]);
  };
}
