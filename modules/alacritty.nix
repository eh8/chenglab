{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors.bright = {
        black = "0x737475";
        blue = "0x959697";
        cyan = "0xb15928";
        green = "0x2e2f30";
        magenta = "0xdadbdc";
        red = "0xe6550d";
        white = "0xfcfdfe";
        yellow = "0x515253";
      };
      colors.cursor = {
        cursor = "0xb7b8b9";
        text = "0x0c0d0e";
      };
      colors.normal = {
        black = "0x0c0d0e";
        blue = "0x3182bd";
        cyan = "0x80b1d3";
        green = "0x31a354";
        magenta = "0x756bb1";
        red = "0xe31a1c";
        white = "0xb7b8b9";
        yellow = "0xdca060";
      };
      colors.primary = {
        background = "0x0c0d0e";
        foreground = "0xb7b8b9";
      };
      cursor = {
        unfocused_hollow = true;
      };
      cursor.style = {
        blinking = "On";
      };
      window.dimensions = {
        lines = 30;
        columns = 150;
      };
      window.decorations = "transparent";
      window.dynamic_padding = true;
      window.padding = {
        x = 30;
        y = 30;
      };
      font = {
        size = 15;
        normal = {
          family = "Iosevka SS08";
        };
      };
    };
  };
}
