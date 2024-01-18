{
  programs.zsh = {
    enable = true;
    autocd = true;

    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      # home-manager
      hmb = "home-manager build --flake ~/dotfiles";
      hmg = "home-manager generations";
      hmr = "home-manager remove-generations";
      hms = "home-manager switch --flake ~/dotfiles";

      # nix-darwin
      drg = "darwin-rebuild --list-generations";
      drs = "darwin-rebuild switch --flake ~/dotfiles";

      # docker
      dco = "docker-compose";
      dcup = "docker-compose up";
      dcupd = "docker-compose up -d";
      dcdn = "docker-compose down";
      dcl = "docker-compose log";

      # git
      g = "git";
      ga = "git add";
      gb = "git branch";
      gba = "git branch --all";
      gc = "git commit -v";
      gca = "git commit -v -a";
      gcm = "git commit -m";
      gcam = "git commit -a -m";
      gco = "git checkout";
      gcob = "git checkout -b";
      gd = "git diff";
      gdca = "git diff --cached";
      gf = "git fetch";
      gl = "git pull";
      glg = "git lg";
      gp = "git push";
      gr = "git remote";
      gra = "git remote add";
      grv = "git remote -v";
      gsh = "git show";
      gst = "git status";
      gwip = ''git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'';
      gunwip = ''git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'';

      # tmux
      tad = "tmux attach -d -t";
      ts = "tmux new-session -s";
      tl = "tmux list-sessions";

      # klaytn
      ka = "kcn attach http://127.0.0.1:8551";
      kab = "kcn attach http://15.164.192.30:8551";
      kab2 = "kcn attach http://3.39.84.202:8651";
      kac = "kcn attach http://34.64.197.145:8551";
      kac2 = "kcn attach http://15.164.40.103:8551";

      # neovim
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";

      py = "python";
      py3 = "python3";
      x = "unarchive";
    };

    shellGlobalAliases = {
      G = "| grep";
      H = "| head";
      T = "| tail";
      L = "| less";
      LL = "2>&1 | less";
      CA = "2>&1 | cat -A";
      NE = "2> /dev/null";
      NUL = "> /dev/null 2>&1";
    };

    initExtra = ''
      [ -f ~/.yum3.sh ] && source ~/.yum3.sh
      [ -f ~/.config/wezterm/wezterm.sh ] && source ~/.config/wezterm/wezterm.sh
      eval "$(zoxide init zsh)"
      alias -s S=nvim
      alias -s diff=nvim
      alias -s go=nvim
      alias -s hpp=nvim
      alias -s js=nvim
      alias -s json=nvim
      alias -s lua=nvim
      alias -s md=nvim
      alias -s nix=nvim
      alias -s py=nvim
      alias -s rs=nvim
      alias -s sol=nvim
      alias -s toml=nvim
      alias -s ts=nvim
      alias -s tsx=nvim
      alias -s txt=nvim
      alias -s yaml=nvim
      alias -s yml=nvim

      gi() { curl -L -s https://www.gitignore.io/api/$@ ;}
      tenv() {
        [[ $TMUX != "" ]] && eval \
                     $(tmux show-env|sed -e '/^-/d' -e "s/'/'\\\\''' /g " -e "s/=\(.*\)/='\\1'/")
      }

      base64url::encode () { base64 -w0 | tr '+/' '-_' | tr -d '='; }
      base64url::decode () { awk '{ if (length($0) % 4 == 3) print $0"="; else if (length($0) % 4 == 2) print $0"=="; else print $0; }' | tr -- '-_' '+/' | base64 -d; }

      proj() {
          mkdir .flake
          pushd .flake
          nix flake init --template "github:the-nix-way/dev-templates#$1"
          popd
          echo 'use flake path:.flake' > .envrc
      }

      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
      disable -p '#'
      stty start undef > /dev/null 2> /dev/null
    '';

    prezto = {
      enable = true;
      pmodules = [
        "environment"
        "terminal"
        "history"
        "directory"
        "spectrum"
        "utility"
        "archive"
        "osx"
        "tmux"
        "rsync"
        "git"
        "gpg"
        "ssh"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
      ];

      editor = {
        dotExpansion = true;
      };
      ssh = {
        identities = [ "id_rsa" "klaytn-cell.pem" ];
      };
      extraConfig = ''
        zstyle ':prezto:*:*' case-sensitive 'yes'
        zstyle ':prezto:module:git:alias' skip 'yes'
        zstyle ':prezto:module:utility' correct 'no'
      '';
    };
  };
}
