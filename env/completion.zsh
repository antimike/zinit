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
