#!/bin/sh
# Queue a random image from ~/Wallpapers as Ghostty's background.
# Writes wallpaper.conf (included by ghostty/config); Ghostty shows it on its next config reload.
dir="$HOME/Wallpapers"
out="$HOME/.config/ghostty/wallpaper.conf"

current=$(sed -n 's/^background-image = "\(.*\)"$/\1/p' "$out" 2>/dev/null)
pick=$(find "$dir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) ! -path "$current" | sort -R | head -n 1)
[ -n "$pick" ] || exit 0
printf 'background-image = "%s"\n' "$pick" > "$out"
