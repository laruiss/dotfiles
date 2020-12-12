CURRENT_DIR=$(pwd)
echo CURRENT_DIR: $CURRENT_DIR

DOTFILES_PROJECT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

echo DOTFILES_PROJECT_PATH: $DOTFILES_PROJECT_PATH

unlink ~/.zshrc
ln -sv $DOTFILES_PROJECT_PATH/zsh/.zshrc ~

unlink ~/.gitconfig
ln -sv $DOTFILES_PROJECT_PATH/git/.gitconfig ~
