if [ "$EUID" -eq 0 ]; then 
SYMBOL="#";
else
SYMBOL="\$"
fi
PROMPT='%{$fg_bold[red]%}%D %T %{$reset_color%}%{$fg_bold[white]%}$(hostname -I | cut -d " " -f 1) %{$reset_color%}%{$fg_bold[blue]%}${current_dir}%~ %{$reset_color%} 
${SYMBOL} '
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
