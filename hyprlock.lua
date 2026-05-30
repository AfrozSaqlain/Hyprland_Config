local wallust = require("wallust/wallust-hyprland")
local HOME = os.getenv("HOME")
local Scripts = HOME .. "/.config/hypr/scripts"

hl.config({
    general = {
        grace = 1,
        fractional_scaling = 2,
        immediate_render = true,
    }
})

hl.config({
    background = {
        monitor = "",
        path = HOME .. "/.config/rofi/.current_wallpaper",
        color = "rgb(0,0,0)",
        blur_size = 3,
        blur_passes = 2,
        noise = 0.0117,
        contrast = 1.3,
        brightness = 0.8,
        vibrancy = 0.21,
        vibrancy_darkness = 0.0,
    }
})

-- ------------------------------
-- DATE
-- ------------------------------

hl.config({
    label = {
        monitor = "eDP-2",
        text = [[cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B')" </b>"]],
        color = wallust.color13,
        font_size = 18,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, -120",
        halign = "center",
        valign = "center",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = [[cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B')" </b>"]],
        color = wallust.color13,
        font_size = 14,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, -80",
        halign = "center",
        valign = "center",
    }
})

-- ------------------------------
-- TIME
-- ------------------------------

-- Hours
hl.config({
    label = {
        monitor = "eDP-2",
        text = [[cmd[update:1000] echo "$(date +"%H")"]],
        color = wallust.color13,
        font_size = 240,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -100",
        halign = "center",
        valign = "top",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = [[cmd[update:1000] echo "$(date +"%H")"]],
        color = wallust.color13,
        font_size = 150,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -50",
        halign = "center",
        valign = "top",
    }
})

-- Minutes
hl.config({
    label = {
        monitor = "eDP-2",
        text = [[cmd[update:1000] echo "$(date +"%M")"]],
        color = wallust.color12,
        font_size = 240,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -450",
        halign = "center",
        valign = "top",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = [[cmd[update:1000] echo "$(date +"%M")"]],
        color = wallust.color12,
        font_size = 150,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -300",
        halign = "center",
        valign = "top",
    }
})

-- Seconds
hl.config({
    label = {
        monitor = "eDP-2",
        text = [[cmd[update:1000] echo "$(date +"%S")"]],
        color = wallust.color11,
        font_size = 50,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -450",
        halign = "center",
        valign = "top",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = [[cmd[update:1000] echo "$(date +"%S")"]],
        color = wallust.color11,
        font_size = 30,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -280",
        halign = "center",
        valign = "top",
    }
})

-- ------------------------------
-- QUOTE
-- ------------------------------

hl.config({
    label = {
        monitor = "eDP-2",
        text = "If you want to shine like a Sun, first burn like a Sun.",
        color = wallust.color11,
        font_size = 30,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -1150",
        halign = "center",
        valign = "top",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = "If you want to shine like a Sun, first burn like a Sun.",
        color = wallust.color11,
        font_size = 20,
        font_family = "JetBrainsMono Nerd Font ExtraBold",
        position = "0, -750",
        halign = "center",
        valign = "top",
    }
})

-- ------------------------------
-- USER
-- ------------------------------

hl.config({
    label = {
        monitor = "eDP-2",
        text = "  $USER",
        color = wallust.color13,
        font_size = 24,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 280",
        halign = "center",
        valign = "bottom",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = "  $USER",
        color = wallust.color13,
        font_size = 18,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 150",
        halign = "center",
        valign = "bottom",
    }
})

-- ------------------------------
-- INPUT FIELD
-- ------------------------------

hl.config({
    ["input-field"] = {
        monitor = "eDP-2",
        size = "300, 60",
        outline_thickness = 2,
        dots_size = 0.2,
        dots_spacing = 0.2,
        dots_center = true,
        outer_color = wallust.color11,
        inner_color = "rgba(255, 255, 255, 0.1)",
        font_color = wallust.color13,
        capslock_color = "rgb(255,255,255)",
        fade_on_empty = false,
        font_family = "JetBrainsMono Nerd Font",
        placeholder_text = [[<i><span foreground="##ffffff99">Type Password</span></i>]],
        hide_input = false,
        position = "0, 120",
        halign = "center",
        valign = "bottom",
    }
})

hl.config({
    ["input-field"] = {
        monitor = "HDMI-A-1",
        size = "250, 50",
        outline_thickness = 2,
        dots_size = 0.2,
        dots_spacing = 0.2,
        dots_center = true,
        outer_color = wallust.color11,
        inner_color = "rgba(255, 255, 255, 0.1)",
        font_color = wallust.color13,
        capslock_color = "rgb(255,255,255)",
        fade_on_empty = false,
        font_family = "JetBrainsMono Nerd Font",
        placeholder_text = [[<i><span foreground="##ffffff99">Type Password</span></i>]],
        hide_input = false,
        position = "0, 80",
        halign = "center",
        valign = "bottom",
    }
})

-- ------------------------------
-- KEYBOARD LAYOUT
-- ------------------------------

hl.config({
    label = {
        monitor = "eDP-2",
        text = "$LAYOUT",
        color = wallust.color13,
        font_size = 12,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 80",
        halign = "center",
        valign = "bottom",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = "$LAYOUT",
        color = wallust.color13,
        font_size = 10,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 50",
        halign = "center",
        valign = "bottom",
    }
})

-- ------------------------------
-- SYSTEM INFO
-- ------------------------------

-- Uptime
hl.config({
    label = {
        monitor = "eDP-2",
        text = [[cmd[update:60000] echo "<b> "$(uptime -p || ]] .. Scripts .. [[/UptimeNixOS.sh)" </b>"]],
        color = wallust.color13,
        font_size = 18,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 0",
        halign = "right",
        valign = "bottom",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = [[cmd[update:60000] echo "<b> "$(uptime -p || ]] .. Scripts .. [[/UptimeNixOS.sh)" </b>"]],
        color = wallust.color13,
        font_size = 14,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 0",
        halign = "right",
        valign = "bottom",
    }
})

-- Battery
hl.config({
    label = {
        monitor = "eDP-2",
        text = [[cmd[update:1000] echo "<b> "$(]] .. Scripts .. [[/Battery.sh)" </b>"]],
        color = wallust.color13,
        font_size = 18,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 30",
        halign = "right",
        valign = "bottom",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = [[cmd[update:1000] echo "<b> "$(]] .. Scripts .. [[/Battery.sh)" </b>"]],
        color = wallust.color13,
        font_size = 14,
        font_family = "JetBrainsMono Nerd Font",
        position = "0, 20",
        halign = "right",
        valign = "bottom",
    }
})

-- Weather
hl.config({
    label = {
        monitor = "eDP-2",
        text = [[cmd[update:3600000] [ -f "]] .. HOME .. [[/.cache/.weather_cache" ] && cat "]] .. HOME .. [[/.cache/.weather_cache"]],
        color = wallust.color13,
        font_size = 18,
        font_family = "JetBrainsMono Nerd Font",
        position = "50, 0",
        halign = "left",
        valign = "bottom",
    }
})

hl.config({
    label = {
        monitor = "HDMI-A-1",
        text = [[cmd[update:3600000] [ -f "]] .. HOME .. [[/.cache/.weather_cache" ] && cat "]] .. HOME .. [[/.cache/.weather_cache"]],
        color = wallust.color13,
        font_size = 14,
        font_family = "JetBrainsMono Nerd Font",
        position = "30, 0",
        halign = "left",
        valign = "bottom",
    }
})
