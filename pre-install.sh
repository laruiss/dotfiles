#!/bin/sh

read -p "Install locales? [y/N] " LOCALES
read -p "Install oh-my-zsh (and zsh if absent)? [y/N] " OHMYZSH
read -p "Use zsh (defaults to bash)? [y/N] " BASH_OR_ZSH

if [ "$LOCALES" = 'y' ]
then
  sudo locale-gen "fr_FR.UTF-8"
  sudo dpkg-reconfigure locales
fi

if [ "$OHMYZSH" != '' ]
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
  echo "Installing Oh-my-zsh "
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

