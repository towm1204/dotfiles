#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# Helper: create symlink with backup
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "  Backing up existing $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sf "$src" "$dst"
    echo "  Linked $dst → $src"
}

# Claude Code
link "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES_DIR/claude/skills/cleanup-memory/SKILL.md" "$HOME/.claude/skills/cleanup-memory/SKILL.md"
link "$DOTFILES_DIR/claude/skills/remember/SKILL.md" "$HOME/.claude/skills/remember/SKILL.md"

# Zsh
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Git
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Homebrew
if command -v brew &>/dev/null; then
    echo "  Installing Homebrew packages..."
    brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
else
    echo "  Homebrew not found. Install from https://brew.sh then re-run."
fi

# Python (pyenv)
if command -v pyenv &>/dev/null; then
    echo "  Installing Python 3.10.6 via pyenv..."
    pyenv install -s 3.10.6
    pyenv global 3.10.6
else
    echo "  pyenv not found — install Homebrew packages first."
fi

echo "Done! Restart your shell to apply changes."
