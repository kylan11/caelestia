-- Personal Hyprland user config — ThinkPad T14s (Arch Linux).
--
-- Symlinked to ~/.config/caelestia/hypr-user.lua by local/bootstrap.fish and
-- required by hypr/hyprland.lua AFTER all config modules, with the `hl` global
-- live. Everything here is additive / last-wins, so the tracked hypr/ files can
-- stay pristine (= no upstream merge conflicts).
--
-- Machine-specific bits (monitors, kb_layout) differ per machine branch; the
-- structure is identical across branches. Relative to kylan11-arch-desktop this
-- laptop drops: the second monitor and its special-workspace pins, the work
-- launcher/profiles, and the binds/execs for apps not installed here (qps,
-- nemo, whatsie, thunderbird, pavucontrol, open-webui, the usage dashboard).

local vars = require("variables")

-- Non-fatal unbind: hyprland.lua requires this file unprotected, so a bad
-- hl.unbind (wrong key form, already-unbound, etc.) must not abort the rest.
-- Worst case a stale upstream bind survives — caught via `hyprctl binds`.
local function unbind(keys)
    pcall(hl.unbind, keys)
end

--------------------
---- Monitors ------
--------------------
-- Single built-in panel: 1920x1080 on 14", scaled 1.33 for readability.
-- Named-output rules take precedence over hyprland.lua's catch-all monitor, so
-- an external display plugged in later still falls back to preferred/auto.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1.33 })

--------------------
---- Input ---------
--------------------
-- Re-declared after input.lua; Hyprland keywords are last-wins, and setting
-- input:natural_scroll does not disturb input:touchpad:natural_scroll.
hl.config({ input = {
    kb_layout      = "it",
    -- Mice/external pointers. The touchpad is already natural via upstream's
    -- input.lua (input:touchpad:natural_scroll = true), so this is the half
    -- that was still inverted.
    natural_scroll = true,
} })

--------------------
---- New keybinds --
--------------------
-- These keys are free upstream (or freed by hypr-vars.lua overrides), so a
-- plain bind is enough — no unbind needed.
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("missioncenter"))
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("EDITOR=nvim VISUAL=nvim foot k9s"))
hl.bind("SUPER + F12", hl.dsp.exec_cmd("~/.config/caelestia/scripts/toggle-audio-output.sh"))

hl.bind(vars.kbFileExplorerVisual, hl.dsp.exec_cmd("app2unit -- " .. vars.fileExplorerVisual))

------------------------------
---- Replaced upstream binds --
------------------------------
-- These upstream binds are hardcoded (not vars.kb* driven) or change the
-- dispatcher on a var key, so we unbind the upstream key then rebind ours to
-- avoid double-fire (e.g. launching an app twice).

-- Launcher: tap-Super -> SUPER + I
unbind("SUPER + SUPER_L")
hl.bind("SUPER + I", hl.dsp.global("caelestia:launcher"))

-- Drop the direct lock bind (kept only via kbRestoreLock)
unbind(vars.kbLock)

-- Focus: arrows -> vim hjkl
unbind("SUPER + left")
unbind("SUPER + right")
unbind("SUPER + up")
unbind("SUPER + down")
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))

-- Screenshot <-> special-ws swap: SUPER+S = screenshot freeze, SUPER+SHIFT+S = specialws
unbind("SUPER + S")         -- upstream: specialws toggle (vars.kbSpecialWs)
unbind("SUPER + SHIFT + S") -- upstream: screenshot freeze
hl.bind("SUPER + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("caelestia toggle specialws"))

-- App launches wrapped in app2unit (+ browser profile flags)
unbind(vars.kbTerminal)
hl.bind(vars.kbTerminal, hl.dsp.exec_cmd("app2unit -- " .. vars.terminal))
unbind(vars.kbBrowser)
hl.bind(vars.kbBrowser,
    hl.dsp.exec_cmd("app2unit -- " .. vars.browser .. " --password-store=basic --profile-directory=\"Default\""))
unbind(vars.kbEditor)
hl.bind(vars.kbEditor, hl.dsp.exec_cmd("app2unit -- " .. vars.editor))
unbind(vars.kbFileExplorer)
hl.bind(vars.kbFileExplorer, hl.dsp.exec_cmd("app2unit -- " .. vars.fileExplorer))

-- (CTRL+ALT+V is left as upstream's plain pavucontrol bind — the desktop's
-- app2unit wrapper is pointless here since pavucontrol isn't installed.)

--------------------
---- Startup execs -
--------------------
-- Nothing machine-specific to start on this laptop: no hyprpm plugins
-- (split-monitor-workspaces is desktop-only), no usage dashboard, no local LLM
-- stack. execs.lua's own hyprland.start subscription covers the rest.
