# defines all hosts + users + homes.
# reusable behavior is routed via host/user profiles.
{
  den.hosts.x86_64-linux.igloo = {
    users.tux = { };
  };

  den.hosts.aarch64-linux.igloo = {
    users.tux = { };
    intoAttr = [
      "nixosConfigurations"
      "igloo-aarch64-linux"
    ];
  };

  den.hosts.aarch64-darwin.mac = {
    users.song = { };
  };

  # other hosts can also have user tux.
  # den.hosts.x86_64-linux.south = {
  #   wsl = { }; # add nixos-wsl input for this.
  #   users.tux = { };
  #   users.orca = { };
  # };
}
