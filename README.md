# dotfiles

## Prerequisites

- nix (use [determinate installer](https://github.com/DeterminateSystems/nix-installer))

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

On Zsh, run `disable -p '#'`.

## Run

Set `FLAKE_PATH` as one of the followings:

- `~/dotfiles`
- `github:ian0371/dotfiles`

### MacOS

#### nix-darwin

Specific flake output can be specified like `$FLAKE_PATH#hostname`.

```bash
nix run nix-darwin -- switch --flake $FLAKE_PATH
```

### Linux

#### home-manager

Specific flake output can be specified like `$FLAKE_PATH#username@hostname`.

```bash
nix run home-manager -- init --switch $FLAKE_PATH
```

If such error:

```
Could not find suitable profile directory, tried /home/ubuntu/.local/state/home-manager/profiles and /nix/var/nix/profiles/per-user/ubuntu
```

Then, make the directory (or run `nix profile install 'nixpkgs#hello'`).

## Notes

### Broken on Mac

See [link](https://gist.github.com/meeech/0b97a86f235d10bc4e2a1116eec38e7e).

### nix repl

```
nix repl
nix-repl> :lf .
nix-repl> darwinConfigurations
{ Chihyunui-Macmini = { ... }; ianxxui-MacBookPro = { ... }; }
```

### Github package hash

```bash
nix-prefetch-github AstroNvim AstroNvim --rev v3.39.0
```

### Flake update

```bash
nix flake update
```

You might want to rebuild `nix-darwin` and `home-manager`.

### Garbage collection

```bash
nix-collect-garbage -d
```

### Overlay

Example overlay of nixpkgs overlay in `overlays/default.nix`:

```nix
(self: super: {
   neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (previousAttrs: rec {
     version = "0.8.1";
     src = pkgs.fetchFromGitHub {
       owner = "neovim";
       repo = "neovim";
       rev = "v${version}";
       sha256 = "sha256-B2ZpwhdmdvPOnxVyJDfNzUT5rTVuBhJXyMwwzCl9Fac=";
     };
  });
})
```

### Docker systemd

```
$ sudo -s
# systemctl link ~/.nix-profile/etc/systemd/system/*
# systemctl start docker
```

### Flake output

- nix-darwin: `darwinConfigurations.<username>.system`
- home-manager: `homeConfigurations.<username>.activationPackage`

## References

- https://nix-community.github.io/home-manager/index.html
- https://github.com/Misterio77/nix-starter-configs
- https://github.com/mic92/dotfiles
