#!/bin/zsh
PROXY_CMD=()
USE_PROXY=0
INSTALL_SYSTEM_TMUX=0
ASSUME_YES=0

die() {
  print -u2 -- "Error: $*"
  exit 1
}

# Optional remaining arguments are the command prefix (sudo for system files).
copy_config() {
  local source_file=$1 destination=$2 backup
  shift 2
  if [[ ! -f "$source_file" ]]; then
    echo "File $source_file does not exist. Skipping copy to $destination."
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    # mktemp adds a unique suffix, so even same-second runs keep every backup.
    backup=$("$@" mktemp "$destination.bkup.$(date +%Y%m%d-%H%M%S).XXXXXXXX") \
      || die "Could not create a backup file for $destination."
    "$@" cp -pL -- "$destination" "$backup" \
      || die "Could not back up $destination to $backup; destination was not overwritten."
    echo "Backed up $destination to $backup"
  fi
  "$@" cp -- "$source_file" "$destination" || die "Could not copy $destination."
  echo "Copied $source_file to $destination"
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--proxy)
            USE_PROXY=1
            ;;
        --install-system-tmux)
            INSTALL_SYSTEM_TMUX=1
            ;;
        -y|--yes)
            ASSUME_YES=1
            ;;
        -h|--help)
            echo "Usage: $0 [-p|--proxy] [--install-system-tmux] [-y|--yes]"
            exit 0
            ;;
        *)
            die "Unknown option: $1"
            ;;
    esac
    shift
done

# Use the executing user's installed binary and its normal config lookup.
# Do not override HOME, PROXYCHAINS_CONF_FILE, or the current directory.
if (( USE_PROXY )); then
  if proxy_binary=$(whence -p proxychains) || proxy_binary=$(whence -p proxychains4); then
    PROXY_CMD=("$proxy_binary")
  else
    die "--proxy requires a locally installed proxychains or proxychains4 binary in PATH."
  fi
  echo "***Using $proxy_binary with its existing local configuration."
  if (( ! ASSUME_YES )) && [[ -t 0 ]]; then
    read -r "REPLY?Ensure ProxyChains is configured for your SOCKS proxy, then press Enter..." || exit 1
  fi
fi

SYSTEM_CMD=()
if (( INSTALL_SYSTEM_TMUX && EUID != 0 )); then
  whence -p sudo >/dev/null || die "--install-system-tmux requires sudo or root privileges."
  SYSTEM_CMD=(sudo)
fi

### Install oh-my-zsh if it is not already installed
if [ ! -d ~/.oh-my-zsh ]; then
  echo "***Installing oh-my-zsh."
  installer=$(mktemp "${TMPDIR:-/tmp}/initial-setup.XXXXXXXX") \
    || die "Could not create a temporary installer file."
  trap 'rm -f -- "$installer"' EXIT
  # Keep ProxyChains banners out of the script; never run a partial download.
  "${PROXY_CMD[@]}" curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$installer" \
    || die "Could not download the Oh My Zsh installer."
  [[ -s "$installer" ]] || die "The downloaded Oh My Zsh installer is empty."
  # Wrap the installer too: its Git subprocesses must inherit ProxyChains.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes "${PROXY_CMD[@]}" sh "$installer" \
    || die "Oh My Zsh installation failed; configuration files were not copied."
fi

copy_config .tmux.conf "$HOME/.tmux.conf"

### Only system-wide tmux installation needs elevated privileges.
if (( INSTALL_SYSTEM_TMUX )); then
  copy_config .tmux.conf /etc/tmux.conf "${SYSTEM_CMD[@]}"
fi

copy_config .zshrc "$HOME/.zshrc"
copy_config zach.zsh-theme "$HOME/.oh-my-zsh/themes/zach.zsh-theme"

### Wait for user input before ending the script
echo -e "\n***Setup complete! Please review the output above for any errors or warnings."
echo -e "***You should now spawn a new ZSH session by typing:\nzsh\n"
if (( ! ASSUME_YES )) && [[ -t 0 ]]; then
  read -r "REPLY?After reading the above, press Enter to exit the script..."
fi
exit 0
