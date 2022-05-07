#!/bin/zsh

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
