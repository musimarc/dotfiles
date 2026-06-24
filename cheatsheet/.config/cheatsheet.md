# Raccourcis

## Top — les plus utiles

| Touche | Action |
|---|---|
| `jk` | Neovim : sortir du mode insertion |
| `$super+Space` | Lanceur apps (wofi) |
| `$super+Return` | Terminal (alacritty) |
| `$super+f` | Sway : plein écran |
| `$super+r` → `{←↓↑→}` | Sway : mode redimensionner |
| `$super+Shift+q` → `y` | Sway : quitter la session |
| `$super+Tab` | Sway : dernier workspace |
| `$super+b` | Sway : Bluetooth |
| `$super+Shift+v` | Sway : presse-papier (cliphist) |
| `$super+Shift+n` | Sway : night light toggle |
| `$super+o` | Sway : chercher fichier (wofi) |
| `$super+p` | Sway : chercher fichier (fzf) |
| `$super+Shift+p` | Sway : chercher contenu (rg+fzf) |
| `<space>sv` / `<space>sh` | Neovim : split vertical / horizontal |
| `<space>sx` | Neovim : fermer le split |
| `<space>to` / `<space>tx` | Neovim : ouvrir / fermer un tab |
| `<space>tn` / `<space>tp` | Neovim : tab suivant / précédent |
| `<space>nh` | Neovim : clear highlights |
| `C-a |` | tmux : split vertical |
| `C-a -` | tmux : split horizontal |
| `C-a [` | tmux : copy mode (v sélection, y copie) |
| `C-a m` | tmux : zoom pane |
| `C-a Ctrl+s` | tmux-resurrect : sauver la session |
| `C-a Ctrl+r` | tmux-resurrect : restaurer la session |
| `$super+&` | Workspace 1 |
| `$super+é` | Workspace 2 |
| `$super+"` | Workspace 3 |
| `$super+'` | Workspace 4 |
| `$super+(` | Workspace 5 |
| `$super+-` | Workspace 6 |

---

## Sway ($super = Mod4, $alt = Mod1)

| Touche | Action |
|---|---|
| `$super+Return` | Terminal (alacritty) |
| `$super+Space` | Lanceur apps (wofi) |
| `$super+Shift+d` | Lanceur apps (wofi) |
| `$super+q` | Quitter fenêtre |
| `$super+F1` | Afficher ce cheatsheet |
| `$super+l` | Verrouiller écran |
| `$super+f` | Plein écran |
| `$super+h` | Split horizontal |
| `$super+v` | Split vertical |
| `$super+s` | Toggle layout |
| `$super+r` | Mode redimensionner |
| `$super+Shift+q` | Quitter session Sway |
| `$super+Shift+r` | Recharger config |

### Focus / déplacement

| Touche | Action |
|---|---|
| `$super+{←↓↑→}` | Focus direction |
| `$super+Shift+{←↓↑→}` | Déplacer fenêtre |
| `$alt+Ctrl+{←→}` | Workspace suivant/précédent |
| `$super+Tab` | Dernier workspace |

### Workspaces (AZERTY)

| Touche | Action |
|---|---|
| `$super+&` | Workspace 1 |
| `$super+é` | Workspace 2 |
| `$super+"` | Workspace 3 |
| `$super+'` | Workspace 4 |
| `$super+(` | Workspace 5 |
| `$super+-` | Workspace 6 |

| Touche | Action |
|---|---|
| `$super+Shift+{1-6}` | Déplacer vers workspace N |

### Apps

| Touche | Action |
|---|---|
| `$super+b` | Bluetooth |
| `$super+o` | Chercher fichier (wofi) |
| `$super+p` | Chercher fichier (fzf) |
| `$super+Shift+p` | Chercher contenu (rg+fzf) |
| `$super+Shift+v` | Presse-papier (cliphist) |
| `$super+Shift+w` | Chromium |
| `$super+Shift+c` | Google Calendar (workspace 6) |
| `$super+Shift+m` | Gmail (workspace 3) |
| `$super+Shift+f` | Thunar |
| `$super+Shift+n` | Night light toggle |
| `$super+Shift+e` | Menu extinction |
| `Print` | Capture d'écran |

### Hardware — Batterie

| Rappel | Action |
|---|---|
| `batt-alert` | Notification mako critique si batterie ≤ 20% (auto au login) |
| `$super+clic waybar battmode` | Cycle seuils 80% → 90% → 100% |

### Multimédia

| Touche | Action |
|---|---|
| `XF86Audio{Next,Prev,Play,Stop}` | Contrôle musique (mpc) |
| `XF86Audio{Raise,Lower,Mute}` | Volume |
| `XF86MonBrightness{Up,Down}` | Luminosité |

---

## tmux (prefix: `C-a`)

| Touche | Action |
|---|---|
| `C-a` | Prefix |
| `C-a \|` | Split vertical (dans le dossier courant) |
| `C-a -` | Split horizontal (dans le dossier courant) |
| `C-a c` | Nouvelle fenêtre |
| `C-a ,` | Renommer fenêtre |
| `C-a {n,p}` | Fenêtre suivante / précédente |
| `C-a {j,k,l,h}` | Redimensionner pane |
| `C-a m` | Zoom pane |
| `C-a [` | Copy mode |
| `C-a r` | Recharger config |
| `C-a d` | Détacher |
| `C-a s` | Choisir session |
| `C-a x` | Tuer pane |
| `C-a &` | Tuer fenêtre |

Modes vi en copy-mode : `v` sélectionner, `y` copier.

### Plugins

| Touche | Action |
|---|---|
| `C-a S` | vim-tmux-navigator |
| `C-a Ctrl+s` | tmux-resurrect : sauver |
| `C-a Ctrl+r` | tmux-resurrect : restaurer |

---

## Neovim (leader = `<space>`)

| Touche | Action |
|---|---|
| `<leader>` | Espace |
| `jk` | Sortir du mode insertion |
| `<leader>nh` | Clear highlights |
| `<leader>+` | Incrémenter nombre |
| `<leader>-` | Décrémenter nombre |

### Fenêtres

| Touche | Action |
|---|---|
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Égaliser splits |
| `<leader>sx` | Fermer split |

### Tabs

| Touche | Action |
|---|---|
| `<leader>to` | Nouveau tab |
| `<leader>tx` | Fermer tab |
| `<leader>tn` | Tab suivant |
| `<leader>tp` | Tab précédent |
| `<leader>tf` | Buffer courant dans nouveau tab |
