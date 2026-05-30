#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Wallust: derive colors from the current wallpaper and update templates
# Usage: WallustAwww.sh [absolute_path_to_wallpaper]

set -euo pipefail

# Inputs and paths
passed_path="${1:-}"
rofi_link="$HOME/.config/rofi/.current_wallpaper"
wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

# Helper: get focused monitor name (prefer JSON)
get_focused_monitor() {
  if command -v jq >/dev/null 2>&1; then
    hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
  else
    hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}'
  fi
}

# Determine wallpaper_path
wallpaper_path=""
if [[ -n "$passed_path" && -f "$passed_path" ]]; then
  wallpaper_path="$passed_path"
else
  # Try the known cache layouts first, then fall back to the current symlink.
  current_monitor="$(get_focused_monitor)"
  cache_file=""

  for candidate in \
    "$HOME/.cache/awww/$current_monitor" \
    "$HOME/.cache/awww"/*/"$current_monitor" \
    "$HOME/.cache/swww/$current_monitor"
  do
    if [[ -f "$candidate" ]]; then
      cache_file="$candidate"
      break
    fi
  done

  if [[ -n "$cache_file" ]]; then
    # Wait briefly for the daemon to write its cache after an image change.
    for i in {1..10}; do
      if [[ -f "$cache_file" ]]; then
        break
      fi
      sleep 0.1
    done

    # awww/swww cache files are NUL-delimited; pick the first absolute path entry.
    wallpaper_path="$(tr '\0' '\n' < "$cache_file" | awk '/^\// { print; exit }')"
  fi

  if [[ -z "${wallpaper_path:-}" && -L "$rofi_link" ]]; then
    rofi_target="$(readlink -f "$rofi_link" 2>/dev/null || true)"
    if [[ -n "${rofi_target:-}" && -f "$rofi_target" ]]; then
      wallpaper_path="$rofi_target"
    fi
  fi

  if [[ -z "${wallpaper_path:-}" && -f "$wallpaper_current" ]]; then
    wallpaper_path="$wallpaper_current"
  fi
fi

if [[ -z "${wallpaper_path:-}" || ! -f "$wallpaper_path" ]]; then
  # Nothing to do; avoid failing loudly so callers can continue
  exit 0
fi

# Update helpers that depend on the path
ln -sf "$wallpaper_path" "$rofi_link" || true
mkdir -p "$(dirname "$wallpaper_current")"
cp -f "$wallpaper_path" "$wallpaper_current" || true

# Run wallust (silent) to regenerate templates defined in ~/.config/wallust/wallust.toml
# -s is used in this repo to keep things quiet and avoid extra prompts
wallust run -s "$wallpaper_path" || true
