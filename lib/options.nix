{ lib }: {
  mkEnabledOption =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.bool;
      default = true;
      example = false;
    };
}
