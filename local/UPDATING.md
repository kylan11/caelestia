# Updating from upstream — caelestia dots

Personal config lives in override files (`local/caelestia/*.lua` symlinked into
`~/.config/caelestia/`), so the tracked `hypr/**` and `fish/config.fish` stay
byte-identical to upstream and merges are (almost always) conflict-free.

## Remotes (already configured)

```sh
git remote -v
# origin    https://github.com/kylan11/caelestia   (your fork)
# upstream  https://github.com/caelestia-dots/caelestia
```

## Update

```sh
git fetch upstream
git merge upstream/main          # clean: your changes aren't in these files
fish local/bootstrap.fish        # re-link overrides (idempotent; picks up new ones)
hyprctl reload                   # apply live
git push origin <your-branch>    # e.g. kylan11-arch-desktop
```

## If a merge conflict appears

Only the leaf configs you own can conflict — `fastfetch/`, `btop/`, `CLAUDE.md`,
`.gitignore`. The high-churn `hypr/*.lua` / `fish/config.fish` never conflict
(they equal upstream).

```sh
git status                       # list conflicted files
# edit each: keep your side or take upstream's, remove the <<<< ==== >>>> markers
git add <file>
git merge --continue
```

## Rules that keep it conflict-free

- Personal changes go ONLY in `local/caelestia/hypr-vars.lua` (values / keybind
  keys), `local/caelestia/hypr-user.lua` (new/replaced binds, rules, monitors,
  `hl.config`, execs), and `~/.config/caelestia/{user-config.fish, secrets.fish,
  scripts/}`. Never edit tracked `hypr/**` or `fish/config.fish`.
- To replace an upstream bind, `hl.unbind("MODS + KEY")` then `hl.bind(...)` in
  `hypr-user.lua` (avoids double-fire).
- When upstream adopts a fix you had overridden, delete that override from
  `hypr-user.lua` (e.g. the volume-bind fix retired after upstream `9ffafc2`).
- Never commit secrets/PII to this PUBLIC fork — they live in the local-only
  `~/.config/caelestia/secrets.fish` and `scripts/`.

## New machine

```sh
git clone https://github.com/kylan11/caelestia && cd caelestia
git switch <your-machine-branch>      # or create one; edit local/caelestia/* values
fish local/bootstrap.fish
# then create ~/.config/caelestia/secrets.fish + scripts/ (not in this repo)
```
