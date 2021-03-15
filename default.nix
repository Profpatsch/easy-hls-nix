{ callPackage
, fetchzip
, stdenv
  # Optional override for the HLS binaries to support specific GHC versions.
, ghcVersions ? [
    "8.6.4"
    "8.6.5"
    "8.8.2"
    "8.8.3"
    "8.8.4"
    "8.10.2"
    "8.10.3"
    "8.10.4"
  ]
}:
let
  inherit (stdenv) isDarwin isLinux;
  hlsBins = [ "wrapper" ] ++ ghcVersions;

  #############################################################################
  # Derivation attributes & metadata shared across platforms.
  #############################################################################

  pname = "haskell-language-server";
  version = "1.0.0";
  meta = with stdenv.lib; {
    description = ''
      A language server that provides information about Haskell programs to
      IDEs, editors, and other tools.
    '';
    homepage = "https://github.com/haskell/haskell-language-server";
    license = licenses.asl20; # Apache-2.0 license.
    maintainers = [ ];

    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

  #############################################################################
  # Platform-Specific Derivations
  #############################################################################

  macosDrv = callPackage ./macos {
    inherit hlsBins pname version meta;
    src = fetchzip {
      url = "https://github.com/haskell/haskell-language-server/releases/download/${version}/haskell-language-server-macOS-${version}.tar.gz";
      sha256 = "PXv8k7GebeHHsqOlgju2NIrubApg8JK8OpRNDevTqqU=";
      stripRoot = false;
    };
  };

  nixosDrv = callPackage ./nixos {
    inherit hlsBins pname version meta;
    src = fetchzip {
      url = "https://github.com/haskell/haskell-language-server/releases/download/${version}/haskell-language-server-Linux-${version}.tar.gz";
      sha256 = "oncBl94KOFjsg22mgxucAxa4T5Hq1SjmsGQ3yXXidjI=";
      stripRoot = false;
    };
  };
in

if isDarwin
then macosDrv
else nixosDrv
