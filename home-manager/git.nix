{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    userName = "Chihyun Song";
    userEmail = "ian0371@gmail.com";

    aliases = {
      br = "branch";
      ci = "commit";
      co = "checkout";
      st = "status";
      lg = ''log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'';
      lg1 = ''log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'';
      lg2 = ''log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n"'          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all'';
      lg3 = ''log --graph --abbrev-commit --decorate --format=format:"%C(bold red)%h%C(reset) - %C(white)%s%C(reset) %C(dim white)%C(bold green)(%ar) %C(bold cyan)<%an>%C(reset)%C(bold yellow)%d%C(reset)" --all'';
      pr = ''!f() { git fetch -fu ''${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f'';
      pr-clean = ''!git for-each-ref refs/heads/pr/* --format='%(refname)' | while read ref ; do branch=''${ref#refs/heads/} ; git branch -D $branch ; done'';
      # for bitbucket/stash remotes
      spr = ''!f() { git fetch -fu ''${2:-$(git remote |grep ^upstream || echo origin)} refs/pull-requests/$1/from:pr/$1 && git checkout pr/$1; }; f'';
    };
    diff-so-fancy.enable = true;
    extraConfig = {
      branch.sort = "committerdate";
      column.ui = "auto";
      core = {
        excludesfile = "~/.gitignore";
        trustctime = false;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      difftool = {
        prompt = false;
        trustExitCode = true;
        difftastic = {
          cmd = "${pkgs.difftastic}/bin/difft \"$LOCAL\" \"$REMOTE\"";
        };
      };
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_rsa.pub";
      commit.gpgsign = true;
      init.defaultBranch = "main";
      merge = {
        conflictstyle = "zdiff3";
        tool = "kdiff3";
      };
      mergetool = {
        prompt = false;
        trustExitCode = true;
      };
      pager.difftool = true;
      push = {
        autoSetupRemote = true;
        default = "simple";
        followTags = true;
      };
      pull.rebase = false;
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        autoupdate = true;
        enabled = true;
      };
      submodule.recurse = true;
      tag.sort = "version:refname";
      url."git@github.com:".insteadOf = "https://github.com/";

      # fsckobjects
      transfer.fsckobjects = true;
      fetch = {
        all = true;
        fsckobjects = true;
        prune = true;
      };
      receive.fsckObjects = true;
    };
  };

  home.file.".gitignore".source = ./static/gitignore;
}
