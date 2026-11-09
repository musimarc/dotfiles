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

### Hibernation (system, matériel spécifique)

Les réglages systemd et GRUB du ThinkPad sont conservés sous `system/etc/` et ne sont
pas gérés par Stow. Ils utilisent l’UUID du système de fichiers de swap et son offset
physique ; après recréation de `/swap.img`, recalculer l’offset avec `filefrag -v` et
mettre à jour les deux fichiers qui le référencent. Ces valeurs identifient cette
machine, mais ne sont pas des identifiants d’accès.

Installation manuelle sur cette machine :

```bash
sudo install -Dm644 system/etc/systemd/logind.conf.d/suspend-only.conf /etc/systemd/logind.conf.d/suspend-only.conf
sudo install -Dm644 system/etc/systemd/sleep.conf.d/hibernate-shutdown.conf /etc/systemd/sleep.conf.d/hibernate-shutdown.conf
sudo install -Dm644 system/etc/systemd/system/hibernate-resume-setup.service /etc/systemd/system/hibernate-resume-setup.service
sudo install -Dm644 system/etc/default/grub.d/99-hibernate-resume.cfg /etc/default/grub.d/99-hibernate-resume.cfg
sudo systemctl enable hibernate-resume-setup.service
sudo update-grub
sudo update-initramfs -u -k all
```

Ne pas redémarrer `systemd-logind` depuis une session graphique ; les changements
`SleepOperation` sont pris en compte au prochain démarrage.

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

### Photos : aperçu rapide et fichiers RAW

Le raccourci `$super+Shift+f` conserve **Thunar**. Sélectionner une photo puis appuyer
sur **Espace** ouvre **Swayimg** en surimpression flottante, sans liste ni infos EXIF.
Les flèches **↑ / ↓** passent à la photo précédente/suivante du dossier. **Suppr**
déplace la photo vers la corbeille et passe à la suivante. **Échap** ferme l’aperçu
et sélectionne la dernière photo dans l’onglet Thunar déjà ouvert. Les actions sont
implémentées en Lua pour garder le chemin comme donnée et l’échapper avant tout appel
shell, sans interpolation du chemin dans une commande `exec` de Swayimg.
Swayimg s'appuie sur LibRaw pour les fichiers RAW. Cela évite
Nautilus, Sushi et les composants de session GNOME.

Le menu contextuel des RAW propose aussi **Exporter JPEG auto**. Cette action utilise
RawTherapee en ligne de commande, applique Auto Levels à chaque photo et écrit les
JPEG dans un sous-dossier `JPEG-auto/` sans modifier les RAW.

```bash
sudo apt install --no-install-recommends wtype
sudo apt install --no-install-recommends rawtherapee
stow --no-folding --restow scripts thunar
```

Cette configuration requiert **Swayimg 5.5 ou plus** pour ses API Lua. Le paquet
Ubuntu 26.04 fournit Swayimg 4.7, qui n’est pas compatible ; installer une version
récente depuis la source officielle (actuellement v5.7) avant d’utiliser l’aperçu.
Le script vérifie la version et refuse de lancer l’ancienne version.

Swayimg et LibRaw n’exigent pas GDM, GNOME Shell ni les composants de session GNOME.
Geeqie reste disponible pour parcourir les images manuellement.

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
