#!/bin/zsh
#TODO:
# Add proxy support


#Check if zsh is installed
if [ ! -f /bin/zsh ]; then
  echo "ZSH is not installed. Please install ZSH before continuing. Exiting..."
  exit 1
fi


#Rename tmux config file at /etc/tmux.conf as a backup
mv /etc/tmux.conf /etc/tmux.conf.bkup


#Install oh-my-zsh if it is not already installed
if [ ! -d ~/.oh-my-zsh ]; then
  echo "***Installing oh-my-zsh. If network access is blocked, install manually via proxychains or similar."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


#Move config files into place
#TODO: Check if file exists before copying
echo "***Moving tmux config file into place"
cp .tmux.conf ~/.tmux.conf
echo "***Moving zsh config file into place"
cp .tmux.conf /etc/tmux.conf
echo "***Moving zsh config file into place"
cp .zshrc ~/.zshrc
echo "***Moving zsh theme file into place"
cp zach.zsh-theme ~/.oh-my-zsh/themes/zach.zsh-theme


echo -e "***You should now spawn a new ZSH session by typing:\nzsh"
