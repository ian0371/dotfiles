{ lib, pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      cloudflared
      docker-compose
      gnused
      lazygit
      libsixel
      ncdu
      nix-prefetch-github
      python311
      rustup
      tldr
      # tmux-fingers
      tree-sitter
      websocat
      xclip
    ]
  );

  home.sessionPath = lib.mkAfter [
    "$HOME/.bun/bin"
    "$HOME/kaia/kaia/build/bin"
    "$HOME/.npm-packages/bin"
    "$HOME/.foundry/bin"
    "$HOME/.cargo/bin"
    "$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin"
  ];

  home.file = {
    ".foundry/foundry.toml".source = ../../assets/home/foundry.toml;
    ".npmrc".source = ../../assets/home/npmrc;
    ".ssh" = {
      source = ../../assets/song-home/ssh;
      recursive = true;
    };
  }
  // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    ".hammerspoon".source = ../../assets/song-home/hammerspoon;
  };

  programs.git.settings = {
    commit.gpgsign = true;
    gpg.format = "ssh";
    url."git@github.com:".insteadOf = "https://github.com/";
    user.signingkey = "~/.ssh/id_rsa.pub";
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "0x09D4C53246941CD1";
    };
  };

  programs.zsh.prezto.ssh = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    identities = [
      "id_rsa"
      "core-dev.pem"
    ];
  };

  programs.zsh.shellAliases = {
      hmb = "home-manager build --flake ~/dotfiles";
      hmg = "home-manager generations";
      hmr = "home-manager remove-generations";
      hms = "home-manager switch --flake ~/dotfiles";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      drg = "sudo darwin-rebuild --list-generations";
      drs = "nix run ~/dotfiles#mac -- switch";
    };

  # xdg.configFile = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
  #   "vivaldi/hover.css".source = ../../assets/song-home/vivaldi/hover.css;
  # };
}
