{...}: {
  system.activationScripts.Wallpaper.text = ''
    echo >&2 "Setting up wallpaper..."
    osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"'
  '';
}
