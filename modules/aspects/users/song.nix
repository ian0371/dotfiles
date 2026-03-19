{ den, ... }:
let
  config = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "zsh")
    ];

    homeManager.imports = [ ./_song-home.nix ];
  };
in
{
  den.aspects.song = config;
}
