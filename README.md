# dotfiles

## Prerequisites

- Nix
  Prefer the [Determinate installer](https://github.com/DeterminateSystems/nix-installer):

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

On Zsh, run `disable -p '#'`.

## Common Commands

Update flake inputs:

```bash
nix flake update
```

Inspect outputs:

```bash
nix flake show
```

Build a declared host:

```bash
nix run .#mac
```

Pass another `nh` action to a host package:

```bash
nix run .#mac -- switch
```

Format the repo:

```bash
nix fmt .
```

## VM Workflow

Run the VM helper:

```bash
nix run .#vm
```

If you're on `aarch64-darwin`, run the VM from Docker instead:

```bash
docker compose run --build --rm vm
```

[`compose.yaml`](compose.yaml) bind-mounts the repo into `/workspace` and uses named volumes for `/nix` and `/root/.cache/nix`, so local edits are visible immediately and Nix build outputs are reused.

The container defaults to `QEMU_OPTS=-nographic` so the VM stays usable in a terminal. On Linux hosts with KVM available:

```bash
docker run --rm -it --device /dev/kvm den-vm
```

## Home Manager Notes

`modules/declarations/hosts.nix` is the declaration file for both hosts and standalone homes.

For a non-root server where you only want Home Manager, add a standalone home declaration:

```nix
den.homes.x86_64-linux.ubuntu = { };
den.homes.aarch64-linux.ec2-user = { };
```

Then apply it with:

```bash
home-manager switch --flake .#ubuntu
```

Use `den.homes.<system>.<user> = { };` for Home Manager-only machines.
Use `den.hosts.<system>.<host>.users.<user> = { };` for real host declarations.

## Add a Server

Add the host in [modules/declarations/hosts.nix](./modules/declarations/hosts.nix):

```nix
den.hosts.x86_64-linux.web = {
  users.song = { };
};
```

If you need a custom user, add a user aspect under [modules/aspects/users](./modules/aspects/users), following [song.nix](./modules/aspects/users/song.nix) or [tux.nix](./modules/aspects/users/tux.nix).

Then inspect or apply the host with:

```bash
nix run .#web
nix run .#web -- switch
```

## Add a User

1. Add a user aspect in [modules/aspects/users](./modules/aspects/users).

Example:

```nix
{ den, ... }:
let
  config = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "zsh")
    ];

    homeManager.imports = [ ./_alice-home.nix ];
  };
in
{
  den.aspects.alice = config;
}
```

2. Add optional Home Manager overrides in `_alice-home.nix`.

3. Attach the user to a host in [modules/declarations/hosts.nix](./modules/declarations/hosts.nix):

```nix
den.hosts.aarch64-darwin.mac = {
  users.song = { };
  users.alice = { };
};
```

Or, for Home Manager-only use without root:

```nix
den.homes.x86_64-linux.alice = { };
```

Then apply it with:

```bash
home-manager switch --flake .#alice
```

## Notes

Find GitHub package hashes:

```bash
nix-prefetch-github AstroNvim AstroNvim --rev v3.39.0
```

Garbage collection:

```bash
nix-collect-garbage -d
```

## References

- https://vic.github.io/den
- https://github.com/nix-community/home-manager
- https://github.com/nix-community/nh
