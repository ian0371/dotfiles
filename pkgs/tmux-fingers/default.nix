{ pkgs, stdenv, fetchFromGitHub }:
let
  version = "2.1.4";
in
stdenv.mkDerivation {
  pname = "tmux-fingers";
  inherit version;

  buildInputs = with pkgs; [ crystal shards ];
  src = fetchFromGitHub {
    owner = "Morantron";
    repo = "tmux-fingers";
    rev = version;
    sha256 = "sha256-JdnMLpKqQrPdVYsKzuhhB0j8/9elbCo7JyCDCC+8pGA=";
  };

  buildPhase = ''
    shards build --production
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/tmux-fingers $out/bin
  '';
}
