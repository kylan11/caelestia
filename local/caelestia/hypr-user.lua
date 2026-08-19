-- Personal Hyprland user config — ASUS ROG Strix G16 (EndeavourOS).
--
-- Symlinked to ~/.config/caelestia/hypr-user.lua by local/bootstrap.fish and
-- required by hypr/hyprland.lua AFTER all config modules, with the `hl` global
-- live. Everything here is additive / last-wins, so the tracked hypr/ files can
-- stay pristine (= no upstream merge conflicts).
--
-- Machine-specific bits (monitor, kb_layout) differ per machine branch; the
-- structure is identical across branches. Relative to kylan11-arch-desktop this
-- laptop drops: the second monitor and its special-workspace pins, the extra
-- browser profiles, the calculator, whatsie/qps/nemo (not installed), and every
-- startup exec (no hyprpm plugins, no usage dashboard, no local LLM stack).

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
-- Single built-in panel: 1920x1200 @165Hz on 16", scaled 1.2 for readability.
-- Named-output rules take precedence over hyprland.lua's catch-all monitor, so
-- an external display plugged in later still falls back to preferred/auto.
hl.monitor({ output = "eDP-2", mode = "preferred", position = "0x0", scale = 1.2 })

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
---- Environment ---
--------------------
-- upstream env.lua exports only XCURSOR_*; hyprcursor needs its own pair or it
-- silently falls back to the default theme.
hl.env("HYPRCURSOR_THEME", vars.cursorTheme)
hl.env("HYPRCURSOR_SIZE", vars.cursorSize)
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")

--------------------
---- Rules ---------
--------------------
hl.window_rule({ match = { class = "thunderbird" }, workspace = "special:email" })
hl.window_rule({ match = { class = "teams-for-linux" }, workspace = "special:teams" })

--------------------
---- New keybinds --
--------------------
-- These keys are free upstream (or freed by hypr-vars.lua overrides), so a
-- plain bind is enough — no unbind needed.
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("missioncenter"))
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("EDITOR=nvim VISUAL=nvim kitty -e k9s"))
hl.bind("SUPER + F12", hl.dsp.exec_cmd("~/.config/caelestia/scripts/toggle-audio-output.sh"))

-- Mail/Teams live on special workspaces that only exist once their app runs, so
-- these launch-if-missing first, then toggle.
hl.bind(vars.kbMailWs, hl.dsp.exec_cmd(
    "pgrep -f thunderbird >/dev/null || app2unit -- thunderbird.desktop; caelestia toggle email"))
hl.bind(vars.kbTeamsWs, hl.dsp.exec_cmd(
    "pgrep -f teams-for-linux >/dev/null || app2unit -- teams-for-linux.desktop; caelestia toggle teams"))

hl.bind(vars.kbBrowserWork,
    hl.dsp.exec_cmd("app2unit -- " .. vars.browser .. " --password-store=basic --profile-directory=\"Profile 1\""))
hl.bind(vars.kbFileExplorerVisual, hl.dsp.exec_cmd("app2unit -- " .. vars.fileExplorerVisual))

------------------------------
---- Replaced upstream binds --
------------------------------
-- These upstream binds are hardcoded (not vars.kb* driven) or change the
-- dispatcher on a var key, so we unbind the upstream key then rebind ours to
-- avoid double-fire (e.g. launching an app twice).

-- Focus: arrows -> vim hjkl
unbind("SUPER + left")
unbind("SUPER + right")
unbind("SUPER + up")
unbind("SUPER + down")
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))

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
unbind(vars.kbAudioSettings)
hl.bind(vars.kbAudioSettings, hl.dsp.exec_cmd("app2unit -- " .. vars.audioSettings))

--------------------
---- Startup execs -
--------------------
-- Nothing machine-specific to start on this laptop; execs.lua's own
-- hyprland.start subscription covers everything. The work-session helper
-- (~/.config/caelestia/scripts/work.sh) stays manual, as it was before.
