#!/bin/zsh
#TODO:
# Add proxy support


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Grab Zach's Linux configuration files
git clone https://github.com/FalseProfit/Linux.git
#Move config files into place
mv Linux Zach_Linux_Setup_Files
mv Zach_Linux_Setup_Files/.tmux.conf ~/.tmux.conf
mv Zach_Linux_Setup_Files/.zshrc ~/.zshrc
mv Zach_Linux_Setup_Files/zach.zsh-theme ~/.oh-my-zsh/themes/zach.zsh-theme

#Apply changes to zsh
source ~/.zshrc

echo -e "You should now spawn a new ZSH session by typing:\nzsh"
echo "Consider deleting the tmux config file at /etc/tmux.conf or overwriting it with the new file at ~/.tmux.conf"
