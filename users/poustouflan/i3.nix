{ pkgs, lib, ... }:

let
  bgcolor = "#121C99";
  in-bgcolor = "#363636";
  text = "#ffffff";
  u-bgcolor = "#ff0000";
  indicator = "#8C9EF0";
  in-text = "#969696";
in
{
  enable = true;
  package = pkgs.i3;

  config = rec {
    modifier = "Mod4";
    terminal = "alacritty";

    fonts = {
      #names = [ "Monospace" ];
      size = 16.0;
    };

    window = {
      border = 1;
      titlebar = true;
    };

    # Keybindings
    keybindings = lib.mkOptionDefault {
      "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
      "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
      "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
      "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "${modifier}+Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot full -c -p \"~/Pictures/Screenshots\"";
      "Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
      "${modifier}+L" = "exec --no-startup-id i3lock -i ~/Pictures/Wallpapers/i3lock.png";
      "${modifier}+Tab" = "workspace next";
    };

    modes = { 
      resize = { 
        Down = "resize grow height 10 px or 10 ppt";
        Escape = "mode default";
        Left = "resize shrink width 10 px or 10 ppt";
        Return = "mode default";
        Right = "resize grow width 10 px or 10 ppt";
        Up = "resize shrink height 10 px or 10 ppt";
        ShiftUp = "resize shrink height 2 px or 2 ppt";
        ShiftDown = "resize grow height 2 px or 2 ppt";
        ShiftLeft = "resize shrink width 2 px or 2 ppt";
        ShiftRight = "resize grow width 2 px or 2 ppt";
      };
    };

    colors = {
      focused = {
        border = bgcolor;
        background = bgcolor;
        text = text;
        indicator = indicator;
        childBorder = "#2E9EF4"; # default
      };
      unfocused = {
        border = in-bgcolor;
        background = in-bgcolor;
        text = in-text;
        indicator = in-bgcolor;
        childBorder = "#222222"; # default
      };
      focusedInactive = {
        border = in-bgcolor;
        background = in-bgcolor;
        text = in-text;
        indicator = in-bgcolor;
        childBorder = "#5F676A"; # default
      };
      urgent = {
        border = u-bgcolor;
        background = u-bgcolor;
        text = text;
        indicator = u-bgcolor;
        childBorder = "#900000"; # default
      };
    };

    # assigns = {
    #   "1: Background" = [];
    #   "7: Browser" = [];
    #   "8: Secondary" = [];
    #   "9: Primary" = [];
    #   "10: Discord" = [];
    # };

    gaps = {
      inner = 15;
      outer = 10;
    };

    bars = [
      {
        statusCommand = "i3status -c ${./i3status.conf}";
        fonts = {
          names = [ "Droid Sans Mono" ];
          size = 14.0;
        };
        colors = {
          background = bgcolor;
          separator = "#191919";

          focusedWorkspace = {
            border = bgcolor;
            background = bgcolor;
            text = text;
          };
          inactiveWorkspace = {
            border = in-bgcolor;
            background = in-bgcolor;
            text = text;
          };
          urgentWorkspace = {
            border = u-bgcolor;
            background = u-bgcolor;
            text = text;
          };
        };
      }
    ];

    startup = [
      # Wallpaper
      {
        command = "${pkgs.feh}/bin/feh --bg-scale ~/Pictures/Wallpapers/manifold_garden.png";
        #command = "${pkgs.feh}/bin/feh --bg-scale ~/Pictures/Wallpapers/aperture_pride.jpg";
        always = true;
        notification = false;
      }
      # Network Manager Applet
      {
        command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
        always = true;
        notification = false;
      }
    ];
  };

}
