{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:
let
  binfiles = builtins.foldl' (x: y: x // y) { } (map (file: { ".local/bin/${file}".source = ./static/bin/${file}; }) (builtins.attrNames (builtins.readDir ./static/bin)));
  sshfiles = builtins.foldl' (x: y: x // y) { } (map (file: { ".ssh/${file}".source = ./static/ssh/${file}; }) (builtins.attrNames (builtins.readDir ./static/ssh)));
in
{
  imports = [
    ./git.nix
    ./packages
    ./zsh.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = lib.mkDefault "song";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";
    enableNixpkgsReleaseCheck = false;
    file =
      binfiles
      // sshfiles
      // {
        ".foundry/foundry.toml".source = ./static/foundry.toml;
        ".hammerspoon".source = ./static/hammerspoon;
        ".npmrc".source = ./static/npmrc;
        "${config.xdg.configHome}/tmux/tmux.conf".source = ./static/tmux/tmux.conf;
        "${config.xdg.configHome}/tmux/tmux.conf.local".source = ./static/tmux/tmux.conf.local;
      };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.bun/bin"
      "$HOME/kaia/kaia/build/bin"
      "$HOME/.npm-packages/bin"
      "$HOME/.foundry/bin"
      "$HOME/.cargo/bin"
      "$(${pkgs.go}/bin/go env GOPATH)/bin"
      "${config.xdg.configHome}/tmux/plugins/t-smart-tmux-session-manager/bin"
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LANG = "en_US.UTF-8";
      LS_COLORS = "$(${pkgs.unstable.vivid}/bin/vivid generate catppuccin-latte)";
      DIRENV_LOG_FORMAT = "";
      FZF_DEFAULT_OPTS = ''--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39'';
      NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      T_SESSION_USE_GIT_ROOT = "true";
    };
  };

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    gpg = {
      enable = true;
      settings = {
        default-key = "0x09D4C53246941CD1";
      };
    };
    starship.enable = true;
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  xdg.configFile = {
    "starship.toml".source = ./static/starship.toml;
    "wezterm".source = ./static/wezterm;
    nvim = {
      source = ./static/nvim;
      recursive = true;
    };
  };

  # fast eval time
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
