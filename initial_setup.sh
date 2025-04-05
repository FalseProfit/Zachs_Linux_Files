#!/bin/zsh
#TODO:
# Add proxy support

#Check if zsh is installed
if [ ! -f /bin/zsh ]; then
  echo "ZSH is not installed. Please install ZSH before continuing. Exiting..."
  exit 1
fi


#Install oh-my-zsh if it is not already installed
if [ ! -d ~/.oh-my-zsh ]; then
  echo "***Installing oh-my-zsh. If network access is blocked, install manually via proxychains or similar."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


#Move config files into place
mv .tmux.conf ~/.tmux.conf
mv .zshrc ~/.zshrc
mv zach.zsh-theme ~/.oh-my-zsh/themes/zach.zsh-theme


#Rename tmux config file at /etc/tmux.conf to avoid accidentally loading it
mv /etc/tmux.conf /etc/tmux.conf.bkup


echo -e "***You should now spawn a new ZSH session by typing:\nzsh"
