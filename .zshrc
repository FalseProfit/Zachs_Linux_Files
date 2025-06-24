# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="zach"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%s %Y-%m-%d %H:%M:%S~~~~"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Created by `pipx` on 2024-08-06 15:41:43
export PATH="$PATH:/root/.local/bin"
export PATH="$PATH:/opt"
export PATH="$PATH:/root/Scripts"

export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Check if python2 or python3 is installed
if [[ $(python --version) == Python\ 2.* ]]; then
    python2exist=TRUE
fi

if [[ $(python3 --version) == Python\ 3.* ]]; then
    python3exist=TRUE
fi

alias fp--slash24="cut -d. -f1-3 | sed 's/$/.0\/24/' | sort -uV"
alias fp--mount_vmware_shares="/usr/bin/vmhgfs-fuse .host:/ /root/shares -o subtype=vmhgfs-ffuse,allow_other"
alias fp--ipgrep="grep -oE '([^.]|^)([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])([^.]|$)' | sed 's/ //g'"
alias fp--ipgrepLine="grep -E '([^.]|^)([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])([^.]|$)'"
alias fp--sourcezshrc="source ~/.zshrc"
alias fp--pythonhttpserver="python3 -m http.server --bind 127.0.0.1"
alias fp--postman="/opt/Postman/Postman > /dev/null 2>&1 &"
alias fp--readablehistory="sed 's/;/,,,,,/' ~/.zsh_history | awk -F',,,,,' '{cmd=\$2; sub(/^: /, \"\", \$1); split(\$1, t, \":\"); print strftime(\"%Y-%m-%d %H:%M:%S\", t[1]) \" - \" cmd}'"
alias fp--readablehistoryUTCfromEST="sed 's/;/,,,,,/' ~/.zsh_history | awk -F',,,,,' '{cmd=\$2; sub(/^: /, \"\", \$1); split(\$1, t, \":\"); print strftime(\"%Y-%m-%d %H:%M:%S\", t[1] + 18000) \" - \" cmd}'"
alias fp--readablehistoryUTCfromEDT="sed 's/;/,,,,,/' ~/.zsh_history | awk -F',,,,,' '{cmd=\$2; sub(/^: /, \"\", \$1); split(\$1, t, \":\"); print strftime(\"%Y-%m-%d %H:%M:%S\", t[1] + 14400) \" - \" cmd}'"
alias fp--venv_python2_make="if [[ $(python --version) == Python\ 2.* ]]; then python -m venv venv; fi"
alias fp--venv_python3_make="if [[ $(python3 --version) == Python\ 3.* ]]; then python3 -m venv venv; fi"
alias fp--venv_activate="source ./venv/bin/activate"
alias fp--lower="tr '[:upper:]' '[:lower:]'"
alias fp--upper="tr '[:lower:]' '[:upper:]'"
alias fp--nxc_domain_regex="grep -haP 'domain:((?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,63})'"
