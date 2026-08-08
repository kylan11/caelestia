-- Personal Hyprland user config.
--
-- Symlinked to ~/.config/caelestia/hypr-user.lua by local/bootstrap.fish and
-- required by hypr/hyprland.lua AFTER all config modules, with the `hl` global
-- live. Everything here is additive / last-wins, so the tracked hypr/ files can
-- stay pristine (= no upstream merge conflicts).
--
-- Machine-specific bits (monitors, kb_layout, DP-3 pins) differ per machine
-- branch; the structure is identical across branches.

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
-- Named-output rules take precedence over upstream's catch-all monitor, so we
-- just add ours; other outputs still fall back to preferred/auto.
hl.monitor({ output = "DP-1", mode = "3440x1440@180", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "760x-1080", scale = 1 })

--------------------
---- Input / misc --
--------------------
-- Re-declared after input.lua / misc.lua; Hyprland keywords are last-wins.
hl.config({ input = { kb_layout = "it" } })
hl.config({ misc = { vrr = 0 } })

--------------------
---- Rules ---------
--------------------
hl.window_rule({ match = { class = "thunderbird" }, workspace = "special:email" })
hl.window_rule({ match = { class = "teams-for-linux" }, workspace = "special:teams" })

-- Pin special workspaces to the secondary monitor.
hl.workspace_rule({ workspace = "special:sysmon", monitor = "DP-3" })
hl.workspace_rule({ workspace = "special:music", monitor = "DP-3" })
hl.workspace_rule({ workspace = "special:communication", monitor = "DP-3" })
hl.workspace_rule({ workspace = "special:todo", monitor = "DP-3" })
hl.workspace_rule({ workspace = "special:email", monitor = "DP-3" })
hl.workspace_rule({ workspace = "special:teams", monitor = "DP-3" })

--------------------
---- New keybinds --
--------------------
-- These keys are free upstream (or freed by hypr-vars.lua overrides), so a
-- plain bind is enough — no unbind needed.
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("missioncenter"))
hl.bind("CTRL + ALT + Escape", hl.dsp.exec_cmd("app2unit -- qps"))
hl.bind("SUPER + ALT + E", hl.dsp.exec_cmd("app2unit -- nemo"))
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("EDITOR=nvim VISUAL=nvim foot k9s"))
hl.bind("SUPER + F12", hl.dsp.exec_cmd("~/.config/caelestia/scripts/toggle-audio-output.sh"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.config/caelestia/scripts/work.sh"))

hl.bind(vars.kbMailWs, hl.dsp.exec_cmd("caelestia toggle email"))
hl.bind(vars.kbTeamsWs, hl.dsp.exec_cmd("caelestia toggle teams"))
hl.bind(vars.kbChatWs, hl.dsp.exec_cmd("app2unit -- whatsie -w"))

hl.bind(vars.kbBrowserWork,
    hl.dsp.exec_cmd("app2unit -- " .. vars.browser .. " --password-store=basic --profile-directory=\"Profile 1\""))
hl.bind(vars.kbBrowserWork2,
    hl.dsp.exec_cmd("app2unit -- " .. vars.browser .. " --password-store=basic --profile-directory=\"Profile 2\""))
hl.bind(vars.kbFileExplorerVisual, hl.dsp.exec_cmd("app2unit -- " .. vars.fileExplorerVisual))
hl.bind(vars.kbCalculator, hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort"))

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
unbind("CTRL + ALT + V")
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd("app2unit -- " .. vars.audioSettings))

-- (Volume @DEFAULT_AUDIO_SINK@ fix retired: upstream adopted it in 9ffafc2 and
-- improved it with a volumeMax variable, so we let upstream's binds stand.)

--------------------
---- Startup execs -
--------------------
-- Additive to execs.lua's own hyprland.start subscription. Only runs at login
-- (not on `hyprctl reload`), so relocating these is safe.
hl.on("hyprland.start", function()
    -- Load hyprpm plugins (split-monitor-workspaces, etc.)
    hl.exec_cmd("hyprpm reload -n")
    -- AI usage dashboard fetcher (feeds the AI Usage tab in the dashboard)
    hl.exec_cmd("python3 ~/.config/quickshell/usage-dashboard/fetch_usage.py")
    -- Local LLM web UI
    hl.exec_cmd("open-webui serve")
end)
