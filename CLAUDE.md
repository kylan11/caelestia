# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Caelestia is a dotfiles repository for a Hyprland-based Linux desktop environment. It contains configuration files for the compositor, shell, terminal, editors, browsers, and various utilities — all with consistent theming via a centralized color scheme system.

The configs are installed via symlinks into `$XDG_CONFIG_HOME` (~/.config), so the repo directory must remain in place after installation.

## Installation

```sh
# Requires fish shell installed
./install.fish [--noconfirm] [--spotify] [--vscode=codium|code] [--discord] [--zen] [--aur-helper=yay|paru]
```

The installer backs up existing configs, installs the `caelestia-meta` AUR package (dependencies defined in `PKGBUILD`), and creates symlinks.

## Architecture

### Hyprland Config Hierarchy (Lua)

Hyprland 1.11+ runs the config as native **Lua** (the `hl.*` API; stubs at
`/usr/share/hypr/stubs/hl.meta.lua`). The chain:

1. **`hypr/hyprland.lua`** — Entry point. Adds `~/.config/caelestia/?.lua` to
   `package.path`, merges user variable overrides, sets monitors, then
   `require()`s each module.
2. **`hypr/scheme/current.lua`** — Color scheme (auto-copied from `default.lua`
   on first launch). A table of colours (`primary`, `surface`, …).
3. **`hypr/variables.lua`** — Returns a table of apps, styling, and all keybind
   keys as `kb*` fields.
4. **`hypr/hyprland/*.lua`** — Modules: `keybinds`, `rules`, `animations`,
   `decoration`, `env`, `execs`, `general`, `input`, `misc`, `gestures`,
   `group`, `functions`.

### Personal customization (override-first — do NOT edit tracked files)

To stay merge-conflict-free on upstream updates, personal changes live **only**
in override files that upstream never touches — never in `hypr/**` or
`fish/config.fish` directly:

- **`~/.config/caelestia/hypr-vars.lua`** — returns a table merged into
  `variables.lua` *before* modules load. For value/keybind-**key** overrides.
  Must never throw (it's required unprotected).
- **`~/.config/caelestia/hypr-user.lua`** — arbitrary Lua run *after* all
  modules. For new/replaced binds (`hl.bind`; `hl.unbind` first to replace an
  upstream bind and avoid double-fire), `hl.window_rule`, `hl.monitor`,
  `hl.config`, and `hl.on("hyprland.start", …)` execs.
- **`~/.config/caelestia/user-config.fish`** — sourced by `fish/config.fish`.
  For fish aliases/functions/env. Secrets go in `secrets.fish` (unversioned,
  sourced by it) — never commit secrets to this PUBLIC repo.

These override files are versioned per machine branch under **`local/caelestia/`**
and symlinked into `~/.config/caelestia/` by **`local/bootstrap.fish`** (re-run
after every `git pull`). Machine-specific values (monitors, `kb_layout`, audio
IDs, VPN path) differ per branch; the `local/` structure is identical.
`user-config.fish`, `secrets.fish`, and personal `scripts/` are local-only
(contain secrets/PII) and are NOT in this public repo.

### External Dependencies

Two companion projects provide runtime functionality (not in this repo):
- **[caelestia-shell](https://github.com/caelestia-dots/shell)** — Desktop shell (panels, launcher, notifications)
- **[caelestia-cli](https://github.com/caelestia-dots/cli)** — CLI tool for color scheme generation and management

### Config Formats

- `.lua` — Hyprland configs (native Lua via the `hl.*` API)
- `.fish` — Fish shell scripts
- `.toml` — Starship prompt (`starship.toml`)
- `.ini` — Foot terminal (`foot/foot.ini`), Spicetify
- `.json`/`.jsonc` — VSCode, Zed, Fastfetch configs
- `.css` — Browser UI customization (Zen/Firefox `userChrome.css`)

## Commit Convention

Format: `module: change` (e.g., `hypr: add plexamp to music special workspace`)

- Module names should be consistent with existing commits
- If multiple changes, use the most impactful one in the commit title; put others in description
- No trailing whitespace; single space between operators
