{ den, lib, ... }:
{
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
  den.ctx.user.includes = [
    den.aspects.base-git
    den.aspects.base-home
    den.aspects.base-zsh
  ];
  den.default = {
    darwin.system.stateVersion = 5;
    nixos.system.stateVersion = "25.11";
    homeManager.home.stateVersion = "25.11";
    nixos.documentation.man.generateCaches = false;

    includes = [
      den.provides.define-user
      den.provides.hostname
      # den.provides.inputs'
    ];
  };
}
