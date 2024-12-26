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

CTRL+S I #To install all tmux plugins

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
