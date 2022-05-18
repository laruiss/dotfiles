#!/bin/sh

read -p "Install Cypress dependencies? [y/N] " CYPRESS_DEPS
read -p "Install scalingo CLI? [y/N] " SCALINGO
read -p "Install node? (Skip or type a major version number) " NODE
read -p "Install Volta? [y/N] " VOLTA
read -p "Install nvm? [y/N] " NVM
#read -p "Install brew? [y/N] " BREW


if [ "$CYPRESS_DEPS" = 'y' ]
then
  echo "Installing Cypress dependencies"
  sudo apt update
  sudo apt upgrade
  sudo apt -y install libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb
  echo "Installing dbus as service"
  sudo /etc/init.d/dbus start &> /dev/null
  echo "Giving sudo rights for current user to start dbus with sudo without passwd"
  USER_HAS_RIGHT=$(sudo grep -q "$USER" /etc/sudoers.d/dbus)
  if [ !$USER_HAS_RIGHT ]
  then
    echo "$USER ALL = (root) NOPASSWD: /etc/init.d/dbus"  | sudo tee -a /etc/sudoers.d/dbus
  fi
fi

if [ "$SCALINGO" = 'y' ]
then
  echo "Installing scalingo CLI"
  curl -O https://cli-dl.scalingo.com/install && bash install
  echo "Installing scalingo zsh completion"
  mkdir -p ~/.zsh/completion
  curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete.zsh" > ~/.zsh/completion/scalingo_complete.zsh
  echo "Uncommenting scalingo zsh completion in ~/.zshrc"
  sed -r -i'' 's/^# (.*scalingo_complete.*)/\1/' ~/.zshrc
fi

if [ "$NODE" != '' ]
then
  echo "Installing node " $NODE
  wget -qO- https://deb.nodesource.com/setup_${NODE}.x | sudo -E bash -
  sudo apt install -y nodejs
fi

if [ "$VOLTA" != '' ]
then
  echo "Installing Volta "
  if [ "$BASH_OR_ZSH" != '' ]
  then
    source ~/.zshrc
  else
    source ~/.bashrc
  fi
fi

if [ "$NVM" != '' ]
then
  echo "Installing nvm "
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  if [ "$BASH_OR_ZSH" != '' ]
  then
    source ~/.zshrc
  else
    source ~/.bashrc
  fi
fi

if [ "$BREW" = 'y' ]
then
  echo "Testing installation"
  IS_ALREADY_INSTALLED=$(test -d /home/linuxbrew/.linuxbrew) && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  if [ ! IS_ALREADY_INSTALLED ]
  then
    echo "Brew not installed yet, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Brew already installed, skipping"
  fi

  PROFILE_CONFED_FOR_BREW=$(test -f ~/.profile && grep -E -q '^.*brew.*' ~/.profile)
  if [ !$PROFILE_CONFED_FOR_BREW ]
  then
    echo "Configuring ~/.profile"
    echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >>~/.profile
  fi

  NEED_ZSH_CONF_FOR_BREW=$(grep -E -q '^eval.*brew.*' ~/.zshrc)
  if [ !$NEED_ZSH_CONF_FOR_BREW ]
  then
    echo "Configuring ~/.zshrc"
    echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >>~/.zshrc
  fi

fi
