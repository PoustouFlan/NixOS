{ pkgs, lib, ... }:

{
  enable = true;
  package = pkgs.i3;

  config = rec {
    modifier = "Mod4";
    terminal = "alacritty";

    window.border = 1;

    # Keybindings
    keybindings = lib.mkOptionDefault {
      "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
      "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
      "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
      "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "${modifier}+Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot full -c -p \"~/Pictures/Screenshots\"";
      "${modifier}+Shift+Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
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

    startup = [
      # Wallpaper
      {
        #command = "${pkgs.feh}/bin/feh --bg-scale ~/Pictures/Wallpapers/aperture.jpg";
        command = "${pkgs.feh}/bin/feh --bg-scale ~/Pictures/Wallpapers/aperture_pride.jpg";
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
