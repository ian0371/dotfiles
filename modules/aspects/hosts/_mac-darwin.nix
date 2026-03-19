{ pkgs, ... }:
{
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Determinate manages the Nix installation.
  nix.enable = false;

  homebrew = {
    enable = true;
    onActivation.upgrade = false;
    onActivation.autoUpdate = false;
    onActivation.cleanup = "uninstall";
    brews = [ ];
    casks = [
      "alfred"
      "bettertouchtool"
      "hammerspoon"
      # "iterm2"
      "kdiff3"
      "keka"
      "wezterm"
    ];
  };

  system.defaults = {
    dock.autohide = true;
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.keyboard.fnState" = true;
    };
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  ids.gids.nixbld = 30000;

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.meslo-lg
  ];
}
