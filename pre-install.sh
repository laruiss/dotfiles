#!/bin/sh

read -p "Install Github CLI? [y/N] " GH
read -p "Install locales? [y/N] " LOCALES
read -p "Install oh-my-zsh (and zsh if absent)? [y/N] " OHMYZSH
read -p "Use zsh (defaults to bash)? [y/N] " BASH_OR_ZSH
read -p "Install laruiss/dotfiles? [y/N] " DOTFILES

if [ "$LOCALES" = 'y' ]
then
  sudo locale-gen "fr_FR.UTF-8"
  sudo dpkg-reconfigure locales
fi

if [ "$GH" = 'y' ]
then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh
fi

if [ "$OHMYZSH" = 'y' ]
then
  if [ "`command -v zsh`" = '' ]
  then
    sudo apt update
    sudo apt install -y zsh
  fi
  if [ "`ls ~/.oh-my-zsh`" != '' ]
  then
    mv ~/.oh-my-zsh ~/.oh-my-zsh.old-`date +%s`
  fi
  if [ "`command -v wget`" = '' ]
  then
    sudo apt update
    sudo apt install -y wget
  fi
  if [ "`command -v sed`" = '' ]
  then
    sudo apt update
    sudo apt install -y sed
  fi
  echo "Installing Oh-my-zsh..."
  wget -O install-oh-my-zsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sed -i'' "s/exec zsh -l/#exec zsh -l/" install-oh-my-zsh.sh
  sh install-oh-my-zsh.sh
fi

if [ "$DOTFILES" = 'y' ]
then
  echo 'Testing git command'
  if [ "`command -v git`" = '' ]
  then
    echo "Installing git... "
    sudo apt update
    sudo apt install git
  fi
  echo "Installing laruiss/dotfiles... "
  git clone https://github.com/laruiss/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  ./install.sh
  ./install-extra.sh
  cd -
fi
