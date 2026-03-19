let
  config = {
    darwin = import ./_mac-darwin.nix;

    homeManager.programs.zsh.shellAliases = {
      drg = "sudo darwin-rebuild --list-generations";
      drs = "nix run ~/dotfiles#mac -- switch";
    };
  };
in
{
  den.aspects.mac = config;
}
