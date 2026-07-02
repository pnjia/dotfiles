#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Documents/dotfiles"

echo "Creating symlinks..."

mkdir -p ~/.config/tmuxinator
mkdir -p ~/.config/fish

ln -sf "$DOTFILES/tmux/"*.yml ~/.config/tmuxinator/
ln -sf "$DOTFILES/tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES/fish/config.fish" ~/.config/fish/config.fish

echo "Done! Symlinks created."
