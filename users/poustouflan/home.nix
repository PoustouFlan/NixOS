{ config, pkgs, specialArgs, lib, ... }:
with pkgs;
let
  osuUpdated = pkgs.osu-lazer.overrideAttrs (oldAttrs:
    {
      version = "2023.617.0";
    }
  );
  my-python-packages = p: with p; [
    requests
    pyyaml
    numpy
    pillow
    matplotlib
    sympy
  ];
  my-python = pkgs.python3.withPackages my-python-packages;
in
{
  # User Packages
  home.packages = with pkgs; [

    # Web
    discord-canary
    slack
    chromium
    evince
    thunderbird

    # Terminal
    sl lolcat gti
    oh-my-zsh zsh-powerlevel10k zplug
    tree
    tig
    ascii
    xclip
    xsel
    man-pages
    bat

    # Tools
    pciutils
    flameshot
    direnv
    xorg.xkill
    libreoffice
    pixelorama gimp
    arandr
    gparted
    obs-studio
    libxml2
    sshfs
    ffmpeg
    cmake
    pre-commit
    graphviz

    # Secu
    burpsuite
    ghidra-bin

    # Yubikey
    yubikey-manager-qt
    yubikey-personalization-gui

    # Code
    my-python
    sageWithDoc
    universal-ctags
    mono
    gdb clang-tools
    python3Packages.ipython
    nixpkgs-fmt
    nodejs_20
    sbcl # lisp
    ghc
    valgrind
    autoconf autoconf-archive automake

    # Notifications
    dunst

    # Games
    osuUpdated
    taisei
    tetrio-desktop
    # (callPackage ./unnamed-sdvx-clone.nix { })

    mtpaint
    masterpdfeditor4
    # teams

    krb5 sshfs
    pdfpc
    jetbrains.rider
    dotnet-sdk_7
    # dotnet-runtime_7

    lsp-plugins pulseeffects-legacy
  ];

  home.file = {
    ".vim/filetype.vim".source = vim/filetype.vim;
    ".vim/UltiSnips/".source = vim/UltiSnips;
  };

  programs = {

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    command-not-found.enable = true;

    # Git Configuration
    git = {
      enable = true;
      userName = "Quentin Rataud";
      userEmail = "quentin.rataud" + "@" + "epita.fr";
      aliases = {
        lg = "log --all --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
      ignores = [ "*~" "*.swp" ".o" ".d" "format_marker"];
      lfs.enable = true;
      extraConfig = {
        user.signingkey = "3C6859C058C43DCF";
        commit.gpgsign = true;
        commit.verbose = true;
        init.defaultbranch = "main";
      };
    };

    # ZSH Configuration
    zsh = {
      enable = true;
      shellAliases = {
        home = "vim ~/Configuration/users/poustouflan/home.nix";
        update = "~/Configuration/apply-users.sh";
        iorgen_activate = "source ~/CP/Prologin/iorgen/.venv/bin/activate";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };
      initExtra = builtins.readFile ./zshrc;
    };

    # Vim Configuration
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
        nerdtree
        ultisnips
        coc-nvim
        coc-pyright
        coc-clangd
        DoxygenToolkit-vim
      ];
      settings = {
        relativenumber = true;
        number = true;
        expandtab = true;
        ignorecase = true;
        shiftwidth = 4;
        tabstop = 8;
      };
      extraConfig = builtins.readFile vim/vimrc;
    };

    # Rofi Configuration
    rofi = {
      enable = true;
      theme = "~/.config/nixpkgs/rofi/lb.rasi";
    };

    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.9;
      };
    };
  };

  services = {

    # Picom Configuration
    picom = {
      enable = true;
      shadow = true;
      vSync = true;
    };

    # GPG Configuration
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "curses";
    };
  };


  # i3
  xsession.windowManager.i3 = import ./i3.nix {inherit pkgs lib;};

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "poustouflan";
  home.homeDirectory = "/home/poustouflan";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";
}
