# Dotfile

## Pre-requisites

Brew is required to install the necessary packages. To install brew, run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Dotfiles are linked to your home directory using [GNU Stow](https://www.gnu.org/software/stow/). To install stow, run the following command:

```bash
brew install stow
```

## Installation

A simple Makefile is provided to install the dotfiles and create the symbolic links. To install the dotfiles, run the following command:

```bash
make
```

## Applications

### Tmux

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

CTRL+A I #To install all tmux plugins (prefix is C-a)

### Nvm

Installing node tools

```bash
nvm install --lts
npm install -g typescript-language-server typescript
```

### Brew

Command to install and update all app referenced in Brewfile config file

```bash
bbic
```

### Zsh

The zshrc sources secrets from the `~/.secrets` file, which is not included in this repository.

### Sway (Wayland, Ubuntu)

Window manager setup migrated from i3 (X11) to Sway (Wayland). Packages: `sway`,
`waybar` (Nord-themed bar), `wofi` (Nord-themed launcher), `i3` (kept for reference),
`scripts` (file search via wofi/fzf, content search via ripgrep+fzf, in `~/.local/bin`).

Required tools (Ubuntu): `sudo apt install sway swaybg swayidle swaylock waybar wofi
mako-notifier grim slurp wl-clipboard xwayland fzf ripgrep bat`.

### LightDM (system, not stow-managed)

The greeter config lives under `system/` (mirrors the real `/etc` path) and is **not**
linked by `make` (excluded in the Makefile). Install it manually:

```bash
sudo install -Dm644 ~/.wallpaper.png /usr/share/backgrounds/i3-wallpaper.png
sudo cp system/etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
```

### GTK theme (Nordic)

The `gtk` package stows `~/.config/gtk-3.0/settings.ini`. Under Wayland, GTK apps read
the theme from **gsettings** (via `xdg-desktop-portal-gtk`), not settings.ini — so use
**`nwg-look`** (the Wayland equivalent of lxappearance; lxappearance is X11-only and has
no effect here). Setup on a fresh machine:

```bash
# Tool + icons
sudo apt install -y nwg-look papirus-icon-theme
# Nordic GTK theme (not packaged) -> ~/.themes
mkdir -p ~/.themes && curl -fL https://github.com/EliverLara/Nordic/releases/latest/download/Nordic.tar.xz | tar -xJ -C ~/.themes
# Apply (gsettings is what the Wayland portal reads)
gsettings set org.gnome.desktop.interface gtk-theme 'Nordic'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### Scripts & systemd timers (automation)

The `scripts` package (`~/.local/bin`) holds the automation helpers: `nightlight`
(wlsunset day/night + waybar toggle), `kbd-auto` (keyboard backlight by daylight),
`battmode` / `batt-save` / `batt-travel` (battery charge thresholds via TLP),
`mx-battery-alert.sh` (low-battery popup). The `systemd` package provides their
user timers/services (`kbd-auto`, `mx-battery-alert`).

**Reinstall notes (two gotchas):**

1. **Stow these packages with `--no-folding`.** Plain `stow` tries to *fold*
   `~/.local` or `~/.config` into a single symlink (replacing the whole
   directory). Force per-file links instead:

   ```bash
   stow --no-folding scripts systemd
   ```

2. **Enable the timers manually — it is machine state, not in the repo.** The
   units are *linked* (the unit file is a symlink outside the standard dir), so
   enablement only lives on the machine:

   ```bash
   systemctl --user daemon-reload
   systemctl --user enable --now kbd-auto.timer mx-battery-alert.timer
   ```

   ⚠️ Never `disable`/`reenable` these *linked* units — `disable` removes the
   symlink itself. Use `enable` only.
