# Paquets stow = tous les dossiers SAUF system/ (fichiers système, hors $HOME)
STOW_PKGS = $(filter-out system/,$(wildcard */))

all:
	stow --verbose --target=$$HOME --restow $(STOW_PKGS)
	chmod +x $$HOME/.zsh/functions.sh

delete:
	stow --verbose --target=$$HOME --delete $(STOW_PKGS)
