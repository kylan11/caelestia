-- Personal Hyprland variable overrides — ThinkPad T14s (Arch Linux).
--
-- Symlinked to ~/.config/caelestia/hypr-vars.lua by local/bootstrap.fish and
-- loaded by hypr/hyprland.lua BEFORE the config modules, so these values are
-- merged into hypr/variables.lua. Only VALUE overrides live here (apps, styling,
-- keybind KEYS). New binds / rules / execs live in hypr-user.lua.
--
-- This file must never throw: hyprland.lua requires it unprotected, so an error
-- here aborts the whole config load. Keep it a plain table + guarded extras.
--
-- Differences from kylan11-arch-desktop: no work-app keys (mail/teams/chat), no
-- work browser profiles, no calculator (rofi-calc isn't installed), and a
-- cursor theme that actually exists on this machine.

local overrides = {
    -- Apps
    browser            = "brave",
    editor             = "foot nvim",
    fileExplorer       = "foot ranger",
    fileExplorerVisual = "thunar",

    -- Shadow
    shadowRange       = 20,
    shadowRenderPower = 3,

    -- Window styling
    windowBorderSize = 0,

    -- Misc
    volumeStep  = 5,
    -- Adwaita is the only theme under /usr/share/icons with real cursors here.
    -- The desktop's Sweet-cursors-hyprcursor is not installed on this laptop
    -- (nor is upstream's default sweet-cursors), and a missing theme leaves
    -- XCURSOR_THEME/HYPRCURSOR_THEME pointing at nothing.
    cursorTheme = "Adwaita",

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
    -- Must be remapped off its upstream SUPER+R, which kbFileExplorer takes.
    kbTodoWs = "SUPER + T",

    -- Apps
    kbTerminal           = "SUPER + RETURN",
    kbFileExplorer       = "SUPER + R",
    kbFileExplorerVisual = "SUPER + SHIFT + R",

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
