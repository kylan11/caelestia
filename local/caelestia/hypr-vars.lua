-- Personal Hyprland variable overrides.
--
-- Symlinked to ~/.config/caelestia/hypr-vars.lua by local/bootstrap.fish and
-- loaded by hypr/hyprland.lua BEFORE the config modules, so these values are
-- merged into hypr/variables.lua. Only VALUE overrides live here (apps, styling,
-- keybind KEYS). New binds / rules / execs live in hypr-user.lua.
--
-- This file must never throw: hyprland.lua requires it unprotected, so an error
-- here aborts the whole config load. Keep it a plain table + guarded extras.

local overrides = {
    -- Apps
    browser            = "brave",
    editor             = "foot nvim",
    fileExplorer       = "foot ranger",
    fileExplorerVisual = "thunar",

    -- Touchpad (upstream names this touchScrollFactor but input.lua reads
    -- touchpadScrollFactor, so we must set the name input.lua actually uses)
    touchpadScrollFactor = 0.3,

    -- Shadow
    shadowRange       = 20,
    shadowRenderPower = 3,

    -- Window styling
    windowBorderSize = 0,

    -- Misc
    volumeStep  = 5,
    cursorTheme = "Sweet-cursors-hyprcursor",

    ------------------
    ---- KEYBINDS ----
    ------------------
    -- Only keys whose bind in keybinds.lua is `vars.kb*` driven belong here;
    -- they take effect with zero edits to the (now-pristine) keybinds.lua.
    -- NOTE: kbSpecialWs is deliberately NOT overridden here — the SUPER+S /
    -- SUPER+SHIFT+S screenshot<->specialws swap is done in hypr-user.lua to
    -- avoid a double-bind on SUPER+SHIFT+S.

    -- Workspaces
    kbMoveWinToWs = "SUPER + SHIFT",

    -- Window actions
    kbPinWindow            = "SUPER + ALT + P",
    kbToggleWindowFloating = "SUPER + SHIFT + F",

    -- Special workspaces
    kbTodoWs  = "SUPER + T",
    kbMailWs  = "SUPER + O",
    kbTeamsWs = "SUPER + P",
    kbChatWs  = "SUPER + Y",

    -- Apps
    kbTerminal           = "SUPER + RETURN",
    kbBrowserWork        = "SUPER + E",
    kbBrowserWork2       = "SUPER + SHIFT + E",
    kbFileExplorer       = "SUPER + R",
    kbFileExplorerVisual = "SUPER + SHIFT + R",
    kbCalculator         = "SUPER + End",

    -- Misc
    kbSession     = "SUPER + X",
    kbShowPanels  = "SUPER + ALT + K",
    kbRestoreLock = "SUPER + ALT + X",
}

-- Scheme-derived value, guarded so a missing scheme can never break config load.
local ok, scheme = pcall(require, "scheme.current")
if ok and type(scheme) == "table" and scheme.surfaceContainerHighest then
    overrides.shadowColour = "rgba(" .. scheme.surfaceContainerHighest .. "10)"
end

return overrides
