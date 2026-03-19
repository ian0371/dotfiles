{ den, ... }:
let
  config = {
    includes = [ den.aspects.role-vm ];

    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.vim ];
        programs.zsh.shellAliases = {
          nrs = "nix run ~/dotfiles#igloo";
        };
      };
  };
in
{
  den.aspects.igloo = config;
}
