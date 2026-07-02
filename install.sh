#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Documents/dotfiles"

echo "Creating symlinks..."

mkdir -p ~/.config/tmuxinator
mkdir -p ~/.config/fish

ln -sf "$DOTFILES/tmux/"*.yml ~/.config/tmuxinator/
ln -sf "$DOTFILES/tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES/fish/config.fish" ~/.config/fish/config.fish

# Backup existing nvim config if it's not already a symlink
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  echo "Backing up existing nvim config to ~/.config/nvim.bak"
  mv ~/.config/nvim ~/.config/nvim.bak
fi

ln -sf "$DOTFILES/nvim" ~/.config/nvim

echo "Done! Symlinks created."
