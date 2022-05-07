#!/bin/zsh

## AUTOLOADS
autoload -Uz zed sticky-note
unalias run-help && autoload -Uz run-help


## DOTBARE
export DOTBARE_DIR="${HOME}/.dotbare"
export DOTBARE_TREE="$HOME"
export DOTBARE_KEY="
  --bind=alt-a:toggle-all \
  --bind=alt-j:jump \
  --bind=alt-0:top \
  --bind=alt-s:toggle-sort \
  --bind=alt-t:toggle-preview
"
export DOTBARE_DIFF_PAGER="delta"

## EDITOR
export EDITOR='nvim'
export VISUAL='nvim'

alias edit='nvr -s'

# SPECIAL DIRS
export SOURCE_DIR="$HOME/Source"
export CHEAT="$HOME/.config/cheat/cheatsheets"
export NOTES_DIR="$HOME/notes"

## FZF
typeset preview_cmd='pistol {${FZF_FIELD:-}}'
# FZF default
# Not sure what this next line is for or who told me to put it in here...
# export FZF_BASE=${${:-=fzf}:P:h2}/shell
if [[ -f "$HOME/.fzfrc" ]]; then
    source "$HOME/.fzfrc"
else
    export FZF_DEFAULT_OPTS='--ansi -m --height 50% --border --info=inline --cycle'
    if type fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --color=always"
    elif type rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND="rg -p --hidden --files"
    fi
fi

# Bibtex source for FZF
export FZF_BIBTEX_CACHEDIR="$HOME/.fzf_bibtex_cache"
export FZF_BIBTEX_SOURCES="$PAPIS_LIBRARY/library.bib"

## GOLANG
# For gvm (Golang version manager)
export GVM_ROOT=/home/hactar/.gvm
. $GVM_ROOT/scripts/gvm-default

## HASKELL
export PATH="$HOME/.cabal/bin:$PATH"

## MAN
# # Config for personal "man sections"
# # Sections:
# #       1h      Manpages generated from command helptext using external tools
# #       1n      Personal notes / summaries

export MANPATH="/usr/local/share/man:${MANPATH}"
manpath+=(/home/hactar/.local/share/man)
export MANSECT="1:1p:8:2:3:3p:3pm:4:5:6:7:9:0p:n:l:p:o:1x:2x:3x:4x:5x:6x:7x:8x:1h:1n"

## NIX
. ~/.nix-profile/etc/profile.d/nix.sh

## NPM
export NPM_INSTALL_PREFIX=${NPM_INSTALL_PREFIX:-$HOME/.npm-packages}
export PATH="$HOME/node_modules:$PATH"

mkdir -p $NPM_INSTALL_PREFIX
npm config set prefix $NPM_INSTALL_PREFIX

export PATH="$PATH:$NPM_INSTALL_PREFIX/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_INSTALL_PREFIX/share/man"

## MAGIC FILE EXTENSIONS
declare -a EXTENSIONS=(
    "yml" "yaml"
    "md" "markdown"
    "rst"
    "txt"
)
eval alias -s {$(echo ${(j:,:)EXTENSIONS})}=$CAT

## PAGER
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

## PASS
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
export PASSWORD_STORE_CHARACTER_SET_NO_SYMBOLS='[a-zA-Z0-9!@#$%^&(),.:=?_]'
export PASSWORD_STORE_GENERATED_LENGTH=25
export PASSWORD_STORE_CLIP_TIME=20
# export PASSWORD_STORE_KEY=
# export PASSWORD_STORE_SIGNING_KEY=
# export PASSWORD_STORE_GPG_OPTS=
# export PASSWORD_STORE_PASSWORD_STORE_UMASK=
# export PASSWORD_STORE_X_SELECTION=
# export PASSWORD_STORE_CHARACTER_SET_NO_SYMBOLS=
# Eval Perl-generated env commands
# Suggested by Clerk README

## PERL
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib=~/perl5)

## PHP
export PATH="$HOME/.config/composer/vendor/bin:$PATH" # PHP

## PYENV
export PYENV_SHELL=zsh
source '/home/hactar/.pyenv/libexec/../completions/pyenv.zsh'
command pyenv rehash 2>/dev/null

pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}

# pyenv-virtualenv init code
export PATH="/home/hactar/.pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
export PYENV_VIRTUALENV_INIT=1;

_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "$VIRTUAL_ENV" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};

typeset -g -a precmd_functions

if [[ -z $precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook $precmd_functions);
fi

## READLINE
# Enables use of rl_custom_function hack
# See https://github.com/lincheney/fzf-tab-completion
export LD_PRELOAD=~/.local/lib/librl_custom_function.so
if [[ ! -e $LD_PRELOAD ]] unset LD_PRELOAD

## REDDIT
export TUIR_EDITOR="nvim"
export TUIR_BROWSER="w3m"
export TUIR_URLVIEWER="urlscan"

## RIPGREP
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

## RUBY + GEMS
export PATH="$HOME/.gem/ruby/bin:$PATH"

## RUST
export PATH="$HOME/.cargo/bin:$PATH"
export CARGO="$HOME/.cargo"

# Tempdir for zsh-vi-mode plugin
export ZVM_TMPDIR="$HOME/.cache/nvim/tmp"
mkdir -p $ZVM_TMPDIR

function zvm_init_fzf() {
    [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
}

# TODO: Customize cursor colors with LS_COLORS or LESS_TERMCAP
MODE_CURSOR_VIINS=bar
MODE_CURSOR_REPLACE=$MODE_CURSOR_VIINS
MODE_CURSOR_VICMD="steady underline"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady block"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"

bindkey -v '^R' fzf-history-widget

# Requires external cargo crate "cargo-show"
alias cargo-info='cargo show'

## CHEATSHEETS
alias cht='cht.sh'
alias tutor='cht.sh --shell'

## GIT
alias gmv='git mv'
alias gre='git restore'
alias gu='gitupdate .'  # https://github.com/nikitavoloboev/gitupdate

function gbare() {
  git --git-dir="$1" --work-tree="${2:-$HOME}" $@
}

# hooks (overcommit)
export GIT_TEMPLATE_DIR="$(overcommit --template-dir)"
export GIT_EDITOR='nvr -cc split --remote-wait'


## INFO
alias info='info --vi-keys'

## KITTY
alias icat='kitty +kitten icat'

## LUA + LDOC
ldoc_source=~/Source/LDoc/ldoc.lua
alias ldoc="lua ${ldoc_source}"

# Example of how to call .toggle-command-prefix
# NOTE: `sudo` prefix is already handled by OMZ plugin (bound to Esc-Esc)
function .toggle-sudo () {
	.toggle-command-prefix 'sudo ' 'sudo' \
		'-(S|A|-askpass|h|-help|K|-remove-timestamp|k|-reset-timestamp|l|-list|n|-non-interactive|S|-stdin|V|-version|v|-validate|e|-edit|s|-shell|i|-login|b|-background|E|H|-set-home|P|-preserve-groups|opt_args|(C?|-close-from=|g?|-group=|h?|-host=|p?|-prompt=|r?|-role=|t?|-type=|T?|-command-timeout=|U?|-other-user=|u?|-user=|-preserve-env=)*)' \
		'-(C|-close-from|g|-group|h|-host|p|-prompt|r|-role|t|-type|T|-command-timeout|U|-other-user|u|-user)'
}

function .toggle-run-help () {
        .toggle-command-prefix 'run-help ' 'run-help'
}

zle -N {,.}toggle-run-help
for m in viins vicmd; do
        bindkey -M $m '^[h' toggle-run-help
done

twf-widget() {
  local selected=$(twf --height=0.5)
  BUFFER="$BUFFER$selected"
  zle reset-prompt
  zle end-of-line
  return $ret
}

zle -N twf-widget
bindkey '^T' twf-widget

## COMPLETION AND STYLES
# Suggested in Zsh user guide:
# zstyle ':completion:*' completer _complete _approximate:-one \
#     _complete:-extended _approximate:-four
# zstyle ':completion:*:approximate-one:*' max-errors 1
# zstyle ':completion:*:complete-extended:*' \
#     matcher 'r:|[.,_-]=* r:|=*'
# zstyle ':completion:*:approximate-four:*' max-errors 4

# Ignore object, tilde-, and .dvi files in completion lists
# zstyle ':completion:*:files' ignored-patterns '*?.o' '*?~' '*?.dvi'

# Ensures parameter completions aren't considered when completing a command
# zstyle ':completion:*:-command-:*' tag-order '!parameters'

# Configures "prefix completion" to be used as a "last resort" form of both normal and approximate completion
# Also configures _match completer, which uses globbing to generate completions
setopt complete_in_word     # Necessary for _prefix to work
zstyle ':completion:*' completer _complete _prefix:-complete _match _prefix:-match _approximate _prefix:-approximate
zstyle ':completion:*:prefix-complete:*' completer _complete
zstyle ':completion:*:prefix-approximate:*' completer _approximate
zstyle ':completion:*:prefix-match:*' completer _match

# Configure _all_matches completer and bind it to ^Xl
zle -C all-matches complete-word _generic
bindkey '^Xl' all-matches
zstyle ':completion:all-matches:*' completer _all_matches
zstyle ':completion:all-matches:*' old-matches only

# Include source information in completion listings
zstyle ':completion:*:descriptions' format '%BCompleting %d%b'

# Separate completion lists by group
zstyle ':completion:*' group-name ''    # Assigns each tag its own group
zstyle ':completion:*:-command-' group-order builtins functions commands

# Display option descriptions
zstyle ':completion:*' verbose true
zstyle ':completion:*' auto-description 'specify: %d'   # Manual recommendation

# Display lists of matches in different colors depending on file type
zmodload -i zsh/complist    # -i suppresses messages if the mod is already loaded
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}   # LS_COLORS --> use same colors as GNU ls

# Some fancy custom colors suggested in Zsh user guide
# zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31' # Prints jobs (prefaced by %) in red
zstyle ':completion:*:*:kill:*:jobs' list-colors 'no=01;31' # Same, but preferred bc it's less dependent on output formatting from a single command
# zstyle ':completion:*:*:kill:*:processes' list-colors \
#     '=(#b) #([0-9]#)*=0=01;31'  # Colors the job IDs onl

# Ignore completion functions in completion lists
# Suggested by the manual and by the Zsh user guide
# zstyle ':completion:*:*:-command-:*' tag-order 'functions:-non-comp'
# More sophisticated version using patterns:
zstyle ':completion:*:*:-command-:*' tag-order 'functions:-non-comp:non-completion\ functions *' functions
zstyle ':completion:*:functions-non-comp' ignored-patterns '_*'

# Use menu completion when list is too long for the screen
zstyle ':completion:*' menu select=long-list

# Ensure that yq only completes files ending in .yaml or .yml
zstyle ':completion:*:*:yq:*:*' file-patterns '*.(y(|a)ml|json):yaml-files:YAML\ files'
zstyle ':completion:*:*:jq:*:*' file-patterns '*.json:json-files:JSON\ files'

# Provide the longest-possible unambiguous filepath match
zstyle ':completion:*' expand prefix suffix

# Completion matching rules
# - Case insensitivity and - <--> _ conversions
# - Independent completions of word blocks delimited by [._-]
#   - The ** wildcard here allows the anchor (delimiter) to appear any number of times
# - Partial word matching
#   - "Chunks" of words beginning with capitals or digits are treated as distinct, anchored substrings
# - Substring completion (last resort)
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=** r:|=*' 'r:[^A-Z0-9]||[A-Z0-9]=** r:|=*' 'l:|=* r:|=*'

# Try case-insensitive matching for every command if normal matching fails
zstyle ':completion:*:*:foo:*' tag-order '*' '*:-case'
zstyle ':completion:*-case' matcher 'm:{a-z}={A-Z}'

# Suggested on fzf-tab GH page
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# Styles / completers to consider:
# - _oldlist: Insert into completers style before _complete
