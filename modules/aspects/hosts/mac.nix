let
  config = {
    darwin = import ./_mac-darwin.nix;

    # NOTE: host-level `homeManager.*` config does NOT flow to each user's
    # home-manager in den v0.13+ without explicit plumbing. Darwin-specific
    # user aliases (drs, drg) live in aspects/users/_song-home.nix under an
    # isDarwin guard instead.
  };
in
{
  den.aspects.mac = config;
}
