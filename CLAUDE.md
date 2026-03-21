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

### Hyprland Config Hierarchy

The Hyprland configuration uses a modular source-chain pattern:

1. **`hypr/hyprland.conf`** — Entry point. Sets path variables (`$hypr`, `$hl`, `$cConf`), monitor config, and sources everything below.
2. **`hypr/scheme/current.conf`** — Color scheme (auto-copied from `default.conf` on first launch). Defines color variables like `$primary`, `$surface`, `$onSurfaceVariant`.
3. **`hypr/variables.conf`** — Reusable variables for apps, keybinds, styling (gaps, blur, opacity, borders). All keybind keys are defined here as `$kb*` variables.
4. **`hypr/hyprland/*.conf`** — Functional modules: `keybinds.conf`, `rules.conf`, `animations.conf`, `decoration.conf`, `env.conf`, `execs.conf`, `general.conf`, `input.conf`, `misc.conf`, `gestures.conf`, `group.conf`.

User overrides (not in repo) are loaded from `~/.config/caelestia/hypr-vars.conf` and `~/.config/caelestia/hypr-user.conf`.

### External Dependencies

Two companion projects provide runtime functionality (not in this repo):
- **[caelestia-shell](https://github.com/caelestia-dots/shell)** — Desktop shell (panels, launcher, notifications)
- **[caelestia-cli](https://github.com/caelestia-dots/cli)** — CLI tool for color scheme generation and management

### Config Formats

- `.conf` — Hyprland configs (custom key-value with `source` includes and `$variable` references)
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
