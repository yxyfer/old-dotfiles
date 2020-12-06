#!/bin/sh
# AUTHOR: Mathieu Rivier
# INSTALL dotfiles
# use those commands from the Coding setup folder
source files/terminal/custom/custom_messages.sh

CONFIGS=$(pwd)/files
VIM_PATH=$CONFIGS/vim
TERM_CONFIG_PATH=$CONFIGS/terminal/zshrc_config.sh

check_success_message()
{
    if [ "$1" -eq 0 ]; then
        pass_message "$2" "succeeded $3"
    else
        fail_message "$2" "Failed $3"
        STATUS=1
    fi
}

install_vim()
{
    info_message "INST" "Installing Vim Config"
    STATUS=0
    info_message "LINK" "Linking .vim/ folder to ~/.vim"
    ln -s $VIM_PATH/.vim   ~/.vim
    check_success_message "$?" "LINK" "Linking vim/ folder to ~/.vim"

    info_message "LINK" "Linking .vimrc to ~/.vimrc"
    ln $VIM_PATH/.vimrc ~/.vimrc
    check_success_message "$?" "LINK" "Linking .vimrc to ~/.vimrc"

    # check if successfully linked
    check_success_message "$STATUS" "INST" "installing vim config"
}

install_term()
{
    info_message "INST" "Terminal Config"

    ssh-add

    if [ -d ~/.oh-my-zsh ]; then
        pass_message "PASS" "oh-my-zsh already installed."
    else
        info_message "DWLD" "installing Oh-my-zsh"
        git clone git@github.com:ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        check_success_message "$?" "installing oh-my-zsh"
    fi

    if [ -d ~/.oh-my-zsh/custom/plugins/zsh-z ]; then
        pass_message "PASS" "zsh-z already installed."
    else
        info_message "DWLD" "installing zsh-z"
        git clone git@github.com:agkozak/zsh-z.git ~/.oh-my-zsh/custom/plugins/zsh-z
        check_success_message "$?" "installing zsh-z"
    fi

    if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        pass_message "PASS" "zsh-syntax-highlighting already installed."
    else
        info_message "DWLD" "installing zsh-syntax-highlighting"
        git clone git@github.com:zsh-users/zsh-syntax-highlighting.git
        mv zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins
        check_success_message "$?" "installing zsh-syntax-highlighting"
    fi


    STATUS=0
    info_message "LINK" "Linking zshrc_config to ~/.zsrc"
    ln $TERM_CONFIG_PATH ~/.zshrc
    check_success_message "$?" "LINK" "Linking zshrc_config to ~/.zsrc"

    info_message "SOUR" "Sourcing ~/.zshrc"
    source ~/.zshrc

    end_message "term profile";
}

install_configs()
{
    install_vimrc
    $RET=$?
    if [[ $RET -eq 0 ]]; then
        install_term
        $RET=$?
    fi

    end_message "vim and term profiles"
}
