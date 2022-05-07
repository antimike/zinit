#!/bin/zsh

declare -a EXTENSIONS=(
    "yml" "yaml"
    "md" "markdown"
    "rst"
    "txt"
)

declare -a PAGERS=(
    "less"
    "more"
    "cat"
)

declare -a CATS=(
    "bat"
    "cat"
)

set_by_preference() {
    # exports a value to the env variable named in $1 after checking that it
    # corresponds to a valid command
    # Params:
    #   Name of env variable to set
    #   A list of possible values, ordered by priority.  The first one which
    #   passes validation will be exported
    local varname="$1" && shift
    while [ $# -gt 0 ]; do
        command -v "$1" >/dev/null 2>&1 && {
            export $varname="$1"; return 0
        } || shift
    done
    echo "${(P)varname} not set: Failed to find any executables." >&2
    return -1
}

{
    set_by_preference PAGER "${PAGERS[@]}"
    set_by_preference CAT "${CATS[@]}"
} >/dev/null

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

eval alias -s {$(echo ${(j:,:)EXTENSIONS})}=$CAT

# export PAGER="most"
# Taken from https://www.reddit.com/r/vim/comments/1l304v/use_vim_as_alternative_to_less/
# LESS options:
# (Note that colored manpages are generated by a zsh plugin)
# -R = Nicer highlighting
# -x4 = Set tab stops to 4 spaces.
# -F = Don't open with less if entire file fits on screen.
# -R = Output "raw" control characters. (colors)
# -s = Squeeze multiple blank lines.
# -X = Ignore termcap initialization. With xterms it keeps
#        the last page of the document on the screen. (see
#        http://www.shallowsky.com/linux/noaltscreen.html)
