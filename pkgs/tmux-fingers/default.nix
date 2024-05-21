{ pkgs, stdenv, fetchFromGitHub }:
let
  version = "2.1.5";
in
stdenv.mkDerivation {
  pname = "tmux-fingers";
  inherit version;

  buildInputs = with pkgs; [ crystal shards ];
  src = fetchFromGitHub {
    owner = "Morantron";
    repo = "tmux-fingers";
    rev = version;
    sha256 = "sha256-gR3u5IVgFxd6uj7l8Ou8GnEvh8AkjRFgIWKCviISweQ=";
  };

  buildPhase = ''
    shards build --production
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/tmux-fingers $out/bin
  '';
}
