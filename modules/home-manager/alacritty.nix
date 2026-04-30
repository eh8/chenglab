{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = "0x6e7681";
          blue = "0x79c0ff";
          cyan = "0x39c5cf";
          green = "0x56d364";
          magenta = "0xbc8cff";
          red = "0xffa198";
          white = "0xb1bac4";
          yellow = "0xe3b341";
        };
        cursor = {
          cursor = "0xe6edf3";
          text = "0x0d1117";
        };
        normal = {
          black = "0x484f58";
          blue = "0x58a6ff";
          cyan = "0x39c5cf";
          green = "0x3fb950";
          magenta = "0xbc8cff";
          red = "0xff7b72";
          white = "0xb1bac4";
          yellow = "0xd29922";
        };
        primary = {
          background = "0x0d1117";
          foreground = "0xe6edf3";
        };
      };

      cursor = {
        unfocused_hollow = true;
        style.blinking = "On";
      };

      window = {
        dimensions = {
          lines = 30;
          columns = 150;
        };
        decorations = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.isLinux "Full")
          (lib.mkIf pkgs.stdenv.isDarwin "transparent")
        ];
        dynamic_padding = true;
        padding = {
          x = 30;
          y = 30;
        };
      };

      font = {
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.isLinux 12)
          (lib.mkIf pkgs.stdenv.isDarwin 15)
        ];
        normal = {
          family = "Iosevka Medium";
        };
      };

      keyboard = {
        bindings = [
          {
            key = "Return";
            mods = "Shift";
            chars = "\n";
          }
        ];
      };
    };
  };
}
