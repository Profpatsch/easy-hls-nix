{ callPackage
, fetchzip
, lib
, stdenv
  # Optional override for the HLS binaries to support specific GHC versions.
, ghcVersions ? [
    "8.6.4"
    "8.6.5"
    "8.8.3"
    "8.8.4"
    "8.10.2"
    "8.10.3"
    "8.10.4"
    "8.10.5"
    "9.0.1"
  ]
}:
let
  inherit (stdenv) isDarwin isLinux;
  hlsBins = [ "wrapper" ] ++ ghcVersions;

  #############################################################################
  # Derivation attributes & metadata shared across platforms.
  #############################################################################

  pname = "haskell-language-server";
  version = "1.3.0";
  meta = {
    description = ''
      A language server that provides information about Haskell programs to
      IDEs, editors, and other tools.
    '';
    homepage = "https://github.com/haskell/haskell-language-server";
    license = lib.licenses.asl20; # Apache-2.0 license.
    maintainers = [ ];

    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

  #############################################################################
  # Platform-Specific Derivations
  #############################################################################

in rec {
  nixosSrc = fetchzip {
    url = "https://github.com/haskell/haskell-language-server/releases/download/${version}/haskell-language-server-Linux-${version}.tar.gz";
    sha256 = "02p1dxhbnh3q8x61fhqfvhnlqgyxzf98zj1hjjk32g1sz9hgdf6r";
    stripRoot = false;
  };

  nixosDrv = callPackage ./nixos {
    inherit hlsBins pname version meta;
  };

  macosSrc = fetchzip {
    url = "https://github.com/haskell/haskell-language-server/releases/download/${version}/haskell-language-server-macOS-${version}.tar.gz";
    sha256 = "0mga2m7qx898szfq4w04a3ji7gwh4jm6zasq4xky7c7hwkmr9y5s";
    stripRoot = false;
  };

  macosDrv = callPackage ./macos {
    inherit hlsBins pname version meta;
  };

}
