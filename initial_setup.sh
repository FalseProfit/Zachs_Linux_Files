#!/bin/zsh
#TODO:
# Add proxy support

PROXY_PREFIX=""


# Parse command line arguments for proxy usage
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--proxy) 
            PROXY_PREFIX="proxychains" 
            echo "*** Proxychains support enabled."
            echo "Please ensure that proxychains is properly configured before running this script."
            echo "You can configure proxychains by editing the /etc/proxychains.conf file."
            echo "Press Enter to continue..."
            read
            ;;
        *) 
            ;; # Ignore other arguments
    esac
    shift
done

#Check if zsh is installed
if [ ! -f /bin/zsh ]; then
  echo "ZSH is not installed. Please install ZSH before continuing. Exiting..."
  exit 1
fi

### Install oh-my-zsh if it is not already installed
if [ ! -d ~/.oh-my-zsh ]; then
  echo "***Installing oh-my-zsh. If network access is blocked, install manually via proxychains or similar."
  echo "Please rerun this script after installing oh-my-zsh."
  sh -c "$($PROXY_PREFIX curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

### Rename tmux config file at /etc/tmux.conf as a backup
if [ -f /etc/tmux.conf ]; then
  echo "***Renaming existing tmux config file at /etc/tmux.conf to /etc/tmux.conf.bkup"
else
  echo "No existing tmux config file found at /etc/tmux.conf. Skipping rename."
fi

### Move config files into place
echo "***Moving tmux config file into place"
if [ -f .tmux.conf ]; then
  cp .tmux.conf ~/.tmux.conf && echo "Copied .tmux.conf to ~/.tmux.conf"
else
  echo "File .tmux.conf does not exist. Skipping copy to ~/.tmux.conf."
fi

### Move tmux config file to /etc if it exists in the current directory
echo "***Moving tmux config file to /etc"
if [ -f .tmux.conf ]; then
  cp .tmux.conf /etc/tmux.conf && echo "Copied .tmux.conf to /etc/tmux.conf"
  echo "You may need to restart tmux for the changes to take effect."
else
  echo "File .tmux.conf does not exist. Skipping copy to /etc/tmux.conf."
fi

### Moving zsh config file in to place
echo "***Moving zsh config file in to place"
# Check if the .zshrc file exists before copying
if [ -f .zshrc ]; then
  cp .zshrc ~/.zshrc && echo "Copied .zshrc to ~/.zshrc"
else
  echo "File .zshrc does not exist. Skipping copy to ~/.zshrc."
fi

### Moving zsh theme file in to place
echo "***Moving zsh theme file in to place"
# Check if the theme file exists before copying
if [ -f zach.zsh-theme ]; then
  cp zach.zsh-theme ~/.oh-my-zsh/themes/zach.zsh-theme && echo "Copied zach.zsh-theme to ~/.oh-my-zsh/themes/zach.zsh-theme"
else
  echo "File zach.zsh-theme does not exist. Skipping copy to ~/.oh-my-zsh/themes/zach.zsh-theme."
fi

### Wait for user input before ending the script
echo -e "\n***Setup complete! Please review the output above for any errors or warnings"
echo -e "***You should now spawn a new ZSH session by typing:\nzsh\n"
read -p "After reading the above, press Enter to exit the script..."
