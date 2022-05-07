#!/bin/zsh

# TODO: Customize cursor colors with LS_COLORS or LESS_TERMCAP
export MODE_CURSOR_VIINS=bar
export MODE_CURSOR_REPLACE=$MODE_CURSOR_VIINS
export MODE_CURSOR_VICMD="steady underline"
export MODE_CURSOR_SEARCH="#ff00ff steady underline"
export MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady block"
export MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"


