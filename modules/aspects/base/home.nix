{ den, lib, ... }:
let
  config = {
    homeManager =
      { pkgs, ... }:
      {
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = (
            with pkgs;
            [
              coreutils
              curl
              difftastic
              docker
              htop
              jq
              less
              neovim
              nh
              nodejs
              ripgrep
              tmux
              tree
              unzip
              vivid
              wget
              zoxide
            ]
          );
          file = {
            ".local/bin/ta".source = ../../assets/home/bin/ta;
          };
          sessionPath = [
            "$HOME/.local/bin"
          ];
          sessionVariables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
            LANG = "en_US.UTF-8";
            LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate catppuccin-latte)";
            DIRENV_LOG_FORMAT = "";
            FZF_DEFAULT_OPTS = "--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39";
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
          starship.enable = true;
        };

        xdg.configFile = {
          "starship.toml".source = ../../assets/home/starship.toml;
          "tmux/tmux.conf".source = ../../assets/home/tmux/tmux.conf;
          "tmux/tmux.conf.local".source = ../../assets/home/tmux/tmux.conf.local;
          "wezterm".source = ../../assets/home/wezterm;
          nvim = {
            source = ../../assets/home/astronvim_v6;
            recursive = true;
          };
        };

        manual = {
          html.enable = false;
          json.enable = false;
          manpages.enable = false;
        };

        systemd.user.startServices = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "sd-switch";
      };
  };
in
{
  den.aspects.base-home = config;
}
