---@module 'hl'

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #

-- This is a file where you put your own default apps, default search Engine etc

-- Set your default editor here uncomment and reboot to take effect.
hl.env("EDITOR", "nvim")

-- These two are for UserKeybinds.conf & Waybar Modules
local term = "kitty"
local files = "thunar"

-- Default Search Engine for ROFI Search (SUPER S)
local Search_Engine = "https://www.google.com/search?q={}"

return {
    term = term,
    files = files,
    Search_Engine = Search_Engine,
}
