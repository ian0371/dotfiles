{ den, ... }:
let
  config = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "zsh")
    ];

    nixos = {
      boot.loader.grub.enable = false;
      fileSystems."/".device = "/dev/fake";
      users.users.tux.initialPassword = "tux";
    };
  };
in
{
  den.aspects.tux = config;
}
