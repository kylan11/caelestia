#!/usr/bin/env fish
#
# Symlink this machine branch's versioned Hyprland overrides into
# ~/.config/caelestia/. Idempotent — safe to re-run after `git pull`.
#
# Only the non-sensitive Hyprland overrides are versioned here. The fish layer
# (user-config.fish, secrets.fish) and personal scripts live only under
# ~/.config/caelestia/ because this fork is PUBLIC and they contain secrets/PII.

set -l src (realpath (dirname (status --current-filename)))/caelestia
set -l dst $HOME/.config/caelestia

mkdir -p $dst $dst/scripts

for f in hypr-vars.lua hypr-user.lua
    set -l target $src/$f
    set -l link $dst/$f
    if not test -e $target
        echo "skip: $target missing"
        continue
    end
    # Back up a pre-existing real file (not our symlink) once.
    if test -e $link; and not test -L $link
        mv -n $link $link.bak
        echo "backed up existing $link -> $link.bak"
    end
    ln -sf $target $link
    echo "linked $link -> $target"
end

echo "bootstrap done. Reminder: user-config.fish, secrets.fish and scripts/ are"
echo "local-only (not in this repo) — keep them backed up separately if needed."
