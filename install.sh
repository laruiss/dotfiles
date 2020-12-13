CURRENT_DIR=$(pwd)

DOTFILES_PROJECT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

unlink ~/.zshrc
ln -sv $DOTFILES_PROJECT_PATH/zsh/.zshrc ~

unlink ~/.p10k.zsh
ln -sv $DOTFILES_PROJECT_PATH/zsh/.p10k.zsh ~

unlink ~/.gitconfig
ln -sv $DOTFILES_PROJECT_PATH/git/.gitconfig ~

