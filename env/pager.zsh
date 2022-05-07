#!/bin/zsh

export LESS="-x4Rs"
# To enable colored manpages
# See https://github.com/ohmyzsh/ohmyzsh/issues/4543
export GROFF_NO_SGR=1

if [ -f "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]; then
    # ubuntu 12.10: sudo apt-get install source-highlight
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
elif [ -f "/usr/bin/src-hilite-lesspipe.sh" ]; then
    # fedora 18: sudo yum install source-highlight
    export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi

declare -a EXTENSIONS=(
    "yml" "yaml"
    "md" "markdown"
    "rst"
    "txt"
)
eval alias -s {$(echo ${(j:,:)EXTENSIONS})}=less
