{ pkgs, ... }:
{
  security.pki.certificateFiles =
    let
      pki = (
        pkgs.fetchurl {
          url = "https://vlt.dh3.ludd.ltu.se:8200/v1/pki/ca/pem";
          hash = "sha256-RX7m8fo4WroQbP4RQa0Qfxl2jDx1KncR1wS+y3NuktI=";
        }
      );
      pki-int = (
        pkgs.fetchurl {
          url = "https://vlt.dh3.ludd.ltu.se:8200/v1/pki-int/ca/pem";
          hash = "sha256-U8mUhSJU8ez2eOqFpRfwnC622SNPAFWQhOIBl7LWf8I=";
        }
      );
    in
    [
      "${pki}"
      "${pki-int}"
    ];
}
