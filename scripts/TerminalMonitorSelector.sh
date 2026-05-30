#!/bin/bash

set -euo pipefail

INTERNAL_MONITOR="eDP-2"
TARGET_CONF="$HOME/.config/hypr/monitors.lua"

ensure_terminal() {
    if [[ -t 0 && -t 1 ]]; then
        return 0
    fi

    if [[ "${TERMINAL_MONITOR_SELECTOR_TTY:-0}" == "1" ]]; then
        return 0
    fi

    if command -v kitty >/dev/null 2>&1; then
        exec kitty \
            --class terminal-monitor-selector \
            --title "Monitor Selector" \
            --grab-keyboard \
            -o background_opacity=0.82 \
            -o confirm_os_window_close=0 \
            -o dynamic_background_opacity=yes \
            -o enable_audio_bell=no \
            -o hide_window_decorations=yes \
            -o window_padding_width=18 \
            env TERMINAL_MONITOR_SELECTOR_TTY=1 "$0" "$@"
    fi

    notify-send "Monitor selector failed" "No terminal TTY available for the selector UI"
    exit 1
}

detect_external_monitors() {
    local connector_path
    local connector_name
    local detected=()

    for connector_path in /sys/class/drm/card*-*; do
        [[ -e "$connector_path/status" ]] || continue
        [[ "$(cat "$connector_path/status" 2>/dev/null)" == "connected" ]] || continue

        connector_name="${connector_path##*/}"
        connector_name="${connector_name#*-}"

        case "$connector_name" in
            eDP|eDP-*|LVDS|LVDS-*|DSI|DSI-*)
                continue
                ;;
        esac

        detected+=("$connector_name")
    done

    printf '%s\n' "${detected[@]}"
}

apply_profile() {
    local profile="$1"
    local lines=()
    local external_monitors=()
    local monitor

    mapfile -t external_monitors < <(detect_external_monitors)

    case "$profile" in
        external)
            lines=("hl.monitor({ name = \"$INTERNAL_MONITOR\", res = \"disable\" })")
            for monitor in "${external_monitors[@]}"; do
                [[ -n "$monitor" ]] || continue
                lines+=("hl.monitor({ name = \"$monitor\", res = \"preferred\", pos = \"auto\", scale = 1 })")
            done
            ;;
        internal)
            lines=("hl.monitor({ name = \"$INTERNAL_MONITOR\", res = \"preferred\", pos = \"auto\", scale = 1 })")
            for monitor in "${external_monitors[@]}"; do
                [[ -n "$monitor" ]] || continue
                lines+=("hl.monitor({ name = \"$monitor\", res = \"disable\" })")
            done
            ;;
        both)
            if [[ ${#external_monitors[@]} -eq 1 && "${external_monitors[0]}" == "HDMI-A-1" ]]; then
                lines=(
                    "hl.monitor({ name = \"$INTERNAL_MONITOR\", res = \"2560x1600@240.0\", pos = \"2831x1439\", scale = 1.0, bitdepth = 10 })"
                    "hl.monitor({ name = \"HDMI-A-1\", res = \"1920x1080@60.0\", pos = \"3164x359\", scale = 1.0, bitdepth = 10 })"
                )
            else
                lines=("hl.monitor({ name = \"$INTERNAL_MONITOR\", res = \"preferred\", pos = \"auto\", scale = 1 })")
                for monitor in "${external_monitors[@]}"; do
                    [[ -n "$monitor" ]] || continue
                    lines+=("hl.monitor({ name = \"$monitor\", res = \"preferred\", pos = \"auto\", scale = 1 })")
                done
            fi
            ;;
        *)
            printf 'Unknown profile: %s\n' "$profile" >&2
            exit 1
            ;;
    esac

    if [[ "$profile" != "internal" && ${#external_monitors[@]} -eq 0 ]]; then
        printf 'No connected external monitors detected.\n' >&2
        exit 1
    fi

    {
        printf '---@module '\''hl'\''\n'
        printf '-- Managed by %s\n' "$(basename "$0")"
        printf '-- %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"
        printf '\n%s\n' "${lines[@]}"
    } > "$TARGET_CONF"

    # Reload hyprland to apply the new Lua config
    hyprctl reload >/dev/null

    notify-send "Monitor profile applied" "$profile"
}

ensure_terminal "$@"

choice=$(
    printf '%s\n' \
        $'external\tExternal monitors only\tDisable laptop panel and enable all connected external displays' \
        $'internal\tInternal monitor only\tEnable laptop panel and disable all connected external displays' \
        $'both\tBoth\tEnable the laptop panel together with all connected external displays' |
        fzf \
            --ansi \
            --border=rounded \
            --delimiter=$'\t' \
            --height=12 \
            --layout=reverse \
            --margin=1,2 \
            --no-info \
            --prompt=' monitors > ' \
            --pointer='▶' \
            --marker='•' \
            --separator='─' \
            --tabstop=4 \
            --with-nth=2,3 \
            --header=$'Monitor Layout\nSelect a profile and press Enter' \
            --color='bg+:-1,bg:-1,border:#7aa2f7,fg:#c0caf5,fg+:#ffffff,gutter:-1,header:#9ece6a,hl:#e0af68,hl+:#e0af68,info:#7dcfff,marker:#f7768e,pointer:#bb9af7,prompt:#7dcfff,separator:#414868,spinner:#7dcfff'
)

case "${choice%%$'\t'*}" in
    external) apply_profile external ;;
    internal) apply_profile internal ;;
    both) apply_profile both ;;
    *) exit 0 ;;
esac
