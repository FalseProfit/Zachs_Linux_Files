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
  echo "Please rerun this script after installing oh-my-zsh."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


#Rename tmux config file at /etc/tmux.conf as a backup
mv /etc/tmux.conf /etc/tmux.conf.bkup
#Move config files into place
echo "***Moving tmux config file into place"
if [ -f .tmux.conf ]; then
  cp .tmux.conf ~/.tmux.conf && echo "Copied .tmux.conf to ~/.tmux.conf"
else
  echo "File .tmux.conf does not exist. Skipping copy to ~/.tmux.conf."
fi

echo "***Moving tmux config file to /etc"
if [ -f .tmux.conf ]; then
  cp .tmux.conf /etc/tmux.conf && echo "Copied .tmux.conf to /etc/tmux.conf"
  echo "You may need to restart tmux for the changes to take effect."
else
  echo "File .tmux.conf does not exist. Skipping copy to /etc/tmux.conf."
fi

echo "***Moving zsh config file into place"
if [ -f .zshrc ]; then
  cp .zshrc ~/.zshrc && echo "Copied .zshrc to ~/.zshrc"
else
  echo "File .zshrc does not exist. Skipping copy to ~/.zshrc."
fi

echo "***Moving zsh theme file into place"
if [ -f zach.zsh-theme ]; then
  cp zach.zsh-theme ~/.oh-my-zsh/themes/zach.zsh-theme && echo "Copied zach.zsh-theme to ~/.oh-my-zsh/themes/zach.zsh-theme"
else
  echo "File zach.zsh-theme does not exist. Skipping copy to ~/.oh-my-zsh/themes/zach.zsh-theme."
fi


echo -e "***You should now spawn a new ZSH session by typing:\nzsh"
