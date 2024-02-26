{ pkgs, stdenv, fetchFromGitHub }:
let
  version = "2.1.3";
in
stdenv.mkDerivation {
  pname = "tmux-fingers";
  inherit version;

  buildInputs = with pkgs; [ crystal shards ];
  src = fetchFromGitHub {
    owner = "Morantron";
    repo = "tmux-fingers";
    rev = version;
    sha256 = "sha256-ShRMfEZy2tyL6mvY7SRypqYICMmXez2z+7sxUwt5aXo=";
  };

  buildPhase = ''
    shards build --production
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/tmux-fingers $out/bin
  '';
}
