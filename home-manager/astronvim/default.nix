{ stdenv
, fetchFromGitHub
,
}:
let
  configs = ../static/astronvim;
in
stdenv.mkDerivation {
  name = "astronvim";
  src = fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "v3.44.0";
    sha256 = "sha256-fUfh00iYhLJ89wdvtOLM5vAQkZGXanNboqkUWW6Y3Y4=";
  };

  installPhase = ''
    mkdir -p $out/lua
    cp -r . $out
    cp -r ${configs} $out/lua/user
  '';
}
