{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

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

  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  users.users = {
    yum3 = {
      initialPassword = "admin";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoAaBjHJB09Y/sbFICE3lSJAnhtIO81buZ0267CxDd/V2Dsxxlc400nOpVYOnTFobpIWKMIY6GknjgdMFdUrvfR+R3TgAMfLPUGwLPQKENYuO0VWx7tRZA215ZHe2J2kP+dUc12QZ7qbmcWWfgV/xlkajXEXa/MC5EN9Tupp+68wNuUGSXr1DROsYeIPn7Rj7BXpo7iVXpqHhshb1MmkyrQU93LY7IsDYLCv3Fzp3v2cwUymajj8azb75UOcGiYD/rv52NW/X8wRel7LqzjoKSgDATKX2XpzG4PSPrlgqw5hVdXObn3QYwP71DEOsR+JuRTMp120lnyRNdOYGjug7bhF5oMHASIJIN87rrouuHzNb1Tfs78v/2PNAE2uja/1vnFTcZKaG5ObD74sIMIvd6a2hpMK9ZqBYh6ursDxWHshfWUJ7tPzHOqu1JJiEG1FuTkqzxi06SGf8/t52RPZ0tBzYcYlfJwqSxuJKyCLhd2eFZFH2uxxeEpZg8TCpNvQmK0vM56MQ6QLD1dCxhYUjERVWM7Hmezs08uiRYLsRmNyGqUA8I1GkEeYb9YjYYD3YDh/DKz0zUkm5pA/2S8DBa9ZG1MSPi+pJu3gYvkncGCIPScNl2fzVRCm0/yI3ciWKW+/Nfa8Bt6KlMPLvxVMj43gRRDT7Di55gSsghuJ3cfQ=="
      ];
      extraGroups = [ "wheel" "docker" "networkmanager" "sudo" ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  system.stateVersion = "23.11";
}
