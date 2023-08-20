# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <nixos-hardware/framework/12th-gen-intel>
  ];

  # Flakes
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_1;
  services.fwupd.enable = true;

  networking.hostName = "patate"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the Desktop Environment.
      displayManager.lightdm.enable = true;
      displayManager.defaultSession = "none+i3";
      windowManager.i3.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbOptions = "compose:caps";
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [ pkgs.gutenprint ];
    avahi.enable = true;
    avahi.nssmdns = true;
    avahi.openFirewall = true;


    # Bluetooth
    blueman.enable = true;

    # Enable postgresql
    postgresql.enable = true;

    # Enable OpenSSH
    openssh.enable = true;

    # Enable Fingerprint Reader
    fprintd.enable = true;

    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];

    # Key mapping
    actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -A 2";
        }
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -U 2";
        }
      ];
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable VirtualBox
  virtualisation.virtualbox.host.enable = true;

  environment.variables = { 
    EDITOR = "vim";
    PAGER = "most";
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
    ];

    fontconfig = {
      hinting.enable = true;
      defaultFonts = {
        serif = [ "FiraCodeNerdFontComplete-Regular" ];
        sansSerif = [ "FiraCodeNerdFontComplete-Regular" ];
        monospace = [ "FiraCodeNerdFontCompleteM-Regular" ];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.poustouflan = {
    isNormalUser = true;
    home = "/home/poustouflan";
    description = "PoustouFlan";
    shell = pkgs.zsh;
    uid = 26204;
    initialPassword = "password";
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" "video"];

    # Survival kit
    packages = with pkgs; [
      htop neofetch zip unzip alacritty rofi imagemagick patchelf
      gcc m4 gnumake clang cargo rustup python310
      binutils
      ncmpcpp
      feh
    ];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    emacs
    pavucontrol
    git
    file
    most
    pciutils
    pinentry-curses
  ];


  programs = {
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };

    # Backlight
    light.enable = true;

    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "steam-run"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

