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
      groff # aws man page
      graphviz
      htop
      jq
      lazygit
      less
      libsixel
      neofetch
      nix-prefetch-github
      nodejs
      pinentry
      python311
      ripgrep
      rustup
      thumbs
      tig
      tldr
      tmux
      tree
      tree-sitter
      universal-ctags
      websocat
      wget
      xclip
    ]
    ++ lib.optionals stdenv.isLinux [
      coreutils
      gcc
      gnumake
    ]
    ++ (with pkgs.unstable; [
      awscli2
      circom
      diffsitter
      docker
      docker-compose
      httpie
      neovim
      nixpkgs-fmt
      pigz
      vivid
      zoxide
      zulu # Markdown LSP marksman
    ])
    ++ (with pkgs.python311Packages; [
      pip
    ]);
}
