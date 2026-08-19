-- Personal Hyprland variable overrides — ASUS ROG Strix G16 (EndeavourOS).
--
-- Symlinked to ~/.config/caelestia/hypr-vars.lua by local/bootstrap.fish and
-- loaded by hypr/hyprland.lua BEFORE the config modules, so these values are
-- merged into hypr/variables.lua. Only VALUE overrides live here (apps, styling,
-- keybind KEYS). New binds / rules / execs live in hypr-user.lua.
--
-- This file must never throw: hyprland.lua requires it unprotected, so an error
-- here aborts the whole config load. Keep it a plain table + guarded extras.
--
-- Differences from the other machine branches: kitty is the terminal here (the
-- desktop and the ThinkPad use foot), pavucontrol stands in for upstream's
-- pwvucontrol, and the work mail/teams/browser-profile keys come from
-- kylan11-arch-desktop (the ThinkPad drops them).

local overrides = {
    -- Apps
    terminal           = "kitty",
    browser            = "brave",
    editor             = "kitty -e nvim",
    fileExplorer       = "kitty -e ranger",
    fileExplorerVisual = "thunar",
    -- Upstream defaults to pwvucontrol, which isn't installed on this machine.
    audioSettings      = "pavucontrol",

    -- Shadow
    shadowRange       = 20,
    shadowRenderPower = 3,

    -- Window styling
    windowBorderSize = 0,

    -- Misc
    volumeStep  = 5,
    -- Real hyprcursor theme, present under /usr/share/icons here. HYPRCURSOR_*
    -- is exported alongside XCURSOR_* in hypr-user.lua (upstream sets only the
    -- XCURSOR pair, which leaves hyprcursor falling back).
    cursorTheme = "Sweet-cursors-hyprcursor",

    ------------------
    ---- KEYBINDS ----
    ------------------
    -- Only keys whose bind in keybinds.lua is `vars.kb*` driven belong here;
    -- they take effect with zero edits to the (pristine) keybinds.lua.

    -- Launcher: tap-Super -> SUPER + I. Upstream made this a variable, so no
    -- unbind/rebind dance is needed any more (the `release` flag it adds only
    -- applies to the SUPER + SUPER_L default).
    kbLauncher = "SUPER + I",

    -- Workspaces
    kbMoveWinToWs = "SUPER + SHIFT",

    -- Window actions
    kbPinWindow            = "SUPER + ALT + P",
    kbToggleWindowFloating = "SUPER + SHIFT + F",

    -- Screenshot <-> special-ws swap. Both sides are var-driven and are moved
    -- together, so no key is ever bound twice and no unbind is required.
    kbSpecialWs        = "SUPER + SHIFT + S",
    kbScreenshotFreeze = "SUPER + S",

    -- Special workspaces
    -- kbTodoWs must move off its upstream SUPER + R, which kbFileExplorer takes.
    kbTodoWs  = "SUPER + T",
    -- Custom keys, consumed only by hypr-user.lua (upstream has no such binds).
    kbMailWs  = "SUPER + O",
    kbTeamsWs = "SUPER + P",

    -- Apps
    kbTerminal           = "SUPER + RETURN",
    kbFileExplorer       = "SUPER + R",
    -- Custom keys, consumed only by hypr-user.lua.
    kbBrowserWork        = "SUPER + E",
    kbFileExplorerVisual = "SUPER + SHIFT + R",

    -- Misc
    -- NOTE: kbSession shares SUPER + X with upstream's kbResizeWindow, but that
    -- one is a mouse-drag bind (bindm), so the two coexist — same arrangement
    -- as the desktop and ThinkPad branches.
    kbSession     = "SUPER + X",
    kbShowPanels  = "SUPER + ALT + K",
    kbLock        = "SUPER + SHIFT + L",
    kbRestoreLock = "SUPER + ALT + X",
    -- Freed by moving kbRestoreLock off SUPER + ALT + L.
    kbSleep       = "SUPER + ALT + L",
}

-- Scheme-derived value, guarded so a missing scheme can never break config load.
local ok, scheme = pcall(require, "scheme.current")
if ok and type(scheme) == "table" and scheme.surfaceContainerHighest then
    overrides.shadowColour = "rgba(" .. scheme.surfaceContainerHighest .. "10)"
end

return overrides
