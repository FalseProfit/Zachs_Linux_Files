#!/bin/zsh
#TODO:
# Add proxy support


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


#Move config files into place
mv .tmux.conf ~/.tmux.conf
mv .zshrc ~/.zshrc
mv zach.zsh-theme ~/.oh-my-zsh/themes/zach.zsh-theme


#Rename tmux config file at /etc/tmux.conf to avoid accidentally loading it
mv /etc/tmux.conf /etc/tmux.conf.bkup


echo -e "You should now spawn a new ZSH session by typing:\nzsh"
