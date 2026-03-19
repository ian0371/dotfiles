{ den, ... }:
{
  den.aspects.role-vm = {
    includes = [ (den.provides.tty-autologin "tux") ];
  };
}
