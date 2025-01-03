{ pkgs, stdenv, fetchFromGitHub }:
let
  version = "2.3.1";
in
stdenv.mkDerivation {
  pname = "tmux-fingers";
  inherit version;

  buildInputs = with pkgs; [ crystal shards git openssl cacert ];
  src = fetchFromGitHub {
    owner = "Morantron";
    repo = "tmux-fingers";
    rev = version;
    sha256 = "sha256-cs8ZspLo92nga/9lhtfe1jdkWGXqWV6egUGRr+D6O6Y=";
  };

  buildPhase = ''
    shards build --production
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/tmux-fingers $out/bin
  '';
}
