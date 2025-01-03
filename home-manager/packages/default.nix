{ pkgs
, lib
, ...
}: {
  home.packages = with pkgs;
    [
      bat
      bottom
      coreutils
      curl
      gdu
      gnused
      go
      graphviz
      htop
      jq
      lazygit
      less
      libsixel
      neofetch
      nix-prefetch-github
      nodejs
      python311
      ripgrep
      rustup
      tig
      tldr
      tmux
      tmux-fingers
      tree
      tree-sitter
      universal-ctags
      websocat
      wget
      xclip
      unzip
    ]
    ++ lib.optionals stdenv.isLinux [
      coreutils
      gcc
      gnumake
    ]
    ++ (with pkgs.unstable; [
      cloudflared
      diffsitter
      docker
      docker-compose
      httpie
      neovim
      pigz
      vivid
      zoxide
      zulu # Markdown LSP marksman
    ])
    ++ (with pkgs.python311Packages; [
      pip
    ]);
}
