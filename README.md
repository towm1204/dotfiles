# Dotfiles

Personal machine setup — Claude Code, zsh, git, Homebrew packages.

## New machine setup

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install git & gh
brew install git gh

# 3. Authenticate GitHub
gh auth login

# 4. Clone this repo
git clone git@github.com:towm1204/dotfiles.git ~/dotfiles

# 5. Run install script (symlinks configs, installs brew packages, sets up python)
cd ~/dotfiles && ./install.sh
```

## After install

- Restart your shell
- Install oh-my-zsh: https://ohmyz.sh/#install
- Install zsh-autosuggestions plugin: `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`

## Updating configs

Files are symlinked, so editing e.g. `~/.zshrc` directly edits `~/dotfiles/zsh/.zshrc`. Then:

```bash
cd ~/dotfiles && git add -A && git commit -m "update" && git push
```
