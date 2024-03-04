{...}: {
  system.activationScripts.postUserActivation.text = ''
    echo >&2 "Setting up the wallpaper..."
    osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"'
  '';
}
