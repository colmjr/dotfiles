# dotfiles

One repo, two machines: macbook (macOS) and thinkpad (Arch + Hyprland).
Managed with [GNU stow](https://www.gnu.org/software/stow/).

## Layout

```
shared/     stowed on both machines   (nvim, tmux, zshrc, eza, starship, ...)
macbook/    stowed on the macbook     (yabai, skhd, karabiner, sketchybar, aerospace, ...)
thinkpad/   stowed on the thinkpad    (hypr, Thunar, xfce4, mimeapps, ...)
```

Each directory mirrors the structure of `$HOME`, e.g.
`shared/.config/nvim/` stows to `~/.config/nvim`.

## Setup on a new machine / fresh clone

```sh
git clone https://github.com/colmjr/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh            # auto-detects macbook vs thinkpad
```

Or by hand:

```sh
stow -t ~ shared macbook    # on the macbook
stow -t ~ shared thinkpad   # on the thinkpad
```

## Daily use

Edit files in place, the symlinks mean you are editing this repo.
Then just `git add` / `commit` / `push` from `~/dotfiles`.

After pulling changes that add or remove top-level entries, re-stow:

```sh
cd ~/dotfiles && stow -R -t ~ shared macbook
```

## Adding a new config

1. Decide if it is shared or machine-specific.
2. Move it into the right package, keeping the `$HOME`-relative path:
   `mv ~/.config/foo ~/dotfiles/shared/.config/foo`
3. `stow -R -t ~ shared` (relinks, creating `~/.config/foo` as a symlink).

## Machine-specific overrides

`shared/.zshrc` guards macOS-only bits (homebrew paths, oj, g++ alias)
behind `[[ "$OSTYPE" == darwin* ]]`. Keep that pattern when adding
platform-specific config to shared files.

## Secrets / machine-local files

Never committed (see `.gitignore`): `gh/hosts.yml`, `pi/agent/auth.json`,
`pi/agent/sessions/`, `raycast/extensions/`, `tmux/plugins/`,
`pulse/cookie`, `dconf/user`, etc. Copy these by hand when setting up
a machine.
