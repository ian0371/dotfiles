{
  pkgs,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "2.6.2";
in
stdenv.mkDerivation {
  pname = "tmux-fingers";
  inherit version;

  buildInputs = with pkgs; [
    crystal
    shards
    git
    openssl
    cacert
  ];

  src = fetchFromGitHub {
    owner = "Morantron";
    repo = "tmux-fingers";
    rev = "be6ef53751f1f2bcc0e3e1463319e100eb2d44bd";
    sha256 = "sha256-f18y4Jq5Ab/5KZKv8woMTkFGEY2/f5KeRH0sf6R1l1U=";
  };

  buildPhase = ''
    shards build --production
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/tmux-fingers $out/bin
  '';
}
