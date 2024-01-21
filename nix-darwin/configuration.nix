{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  users.users = {
    song = {
      name = "song";
      home = "/Users/song";
    };
  };

  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";
    brews = [
      "cirruslabs/cli/tart"
    ];
    casks = [
      "alfred"
      "bettertouchtool"
      "iterm2"
      "phoenix"
      "wezterm"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.keyboard.fnState" = true; # use F1 keys as standard function keys
    };
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  security.pam.enableSudoTouchIdAuth = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs.unstable; [
      # https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${fName}.zip
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
  };
}
