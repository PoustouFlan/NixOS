# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  programs.zsh.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "patate"; # Define your hostname.
  networking.networkmanager.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_1;
  # boot.kernelParams = [ "i915.force_probe=46a6" ];
  services.fwupd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.windowManager.i3.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "compose:caps";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable postgresql
  services.postgresql.enable = true;

  # Enable SSH
  services.openssh.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

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
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" ];

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

  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  services.pcscd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

