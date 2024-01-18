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
    rev = "v3.39.0";
    sha256 = "sha256-wttBcj9OoFHx+EukGzQYKHVlApphZXzZqY5zP5chU6g=";
  };

  installPhase = ''
    mkdir -p $out/lua
    cp -r . $out
    cp -r ${configs} $out/lua/user
  '';
}
