all:
	stow --verbose --target=$$HOME --restow */
	chmod +x $$HOME/.zsh/functions.sh

delete:
	stow --verbose --target=$$HOME --delete */
