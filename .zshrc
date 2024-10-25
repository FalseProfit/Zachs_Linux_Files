alias slash24="cut -d. -f1-3 | sed 's/$/.0\/24/'"
alias mount-shares="/usr/bin/vmhgfs-fuse .host:/ /root/shares -o subtype=vmhgfs-ffuse,allow_other"
alias ipgrep="grep -oE '([^.]|^)([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])([^.]|$)'"
