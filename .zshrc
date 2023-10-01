# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!usr/bin/env zsh

# - - - - - - - - - - - - - - - - - - - -
# Profiling Tools
# - - - - - - - - - - - - - - - - - - - -

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    zmodload zsh/zprof
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>${HOME}/.cache/logs/zinit.$$.log
    setopt xtrace prompt_subst
fi

# - - - - - - - - - - - - - - - - - - - -
# Zsh Core Configuration
# - - - - - - - - - - - - - - - - - - - -

# Install Functions.
export XDG_CONFIG_HOME="${HOME}/.config"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

export CACHEDIR="$HOME/.local/share"
[[ -d "$CACHEDIR" ]] || mkdir -p "$CACHEDIR"

export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

### Added by Zinit's installer
if [[ ! -f ${ZINIT_HOME}/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


# Load The Prompt System And Completion System And Initilize Them.
autoload -Uz compinit promptinit

# Load And Initialize The Completion System Ignoring Insecure Directories With A
# Cache Time Of 20 Hours, So It Should Almost Always Regenerate The First Time A
# Shell Is Opened Each Day.
# See: https://gist.github.com/ctechols/ca1035271ad134841284
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
    compinit -i -C
else
    compinit -i
fi
unset _comp_files
promptinit
setopt prompt_subst


# - - - - - - - - - - - - - - - - - - - -
# ZSH Settings
# - - - - - - - - - - - - - - - - - - - -

autoload -U colors && colors    # Load Colors.
unsetopt case_glob              # Use Case-Insensitve Globbing.
setopt globdots                 # Glob Dotfiles As Well.
setopt extendedglob             # Use Extended Globbing.
setopt autocd                   # Automatically Change Directory If A Directory Is Entered.

# Smart URLs.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General.
setopt brace_ccl                # Allow Brace Character Class List Expansion.
setopt combining_chars          # Combine Zero-Length Punctuation Characters ( Accents ) With The Base Character.
setopt rc_quotes                # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt mail_warning           # Don't Print A Warning Message If A Mail File Has Been Accessed.

# Jobs.
setopt long_list_jobs           # List Jobs In The Long Format By Default.
setopt auto_resume              # Attempt To Resume Existing Job Before Creating A New Process.
setopt notify                   # Report Status Of Background Jobs Immediately.
unsetopt bg_nice                # Don't Run All Background Jobs At A Lower Priority.
unsetopt hup                    # Don't Kill Jobs On Shell Exit.
unsetopt check_jobs             # Don't Report On Jobs When Shell Exit.

setopt correct                  # Turn On Corrections

# Completion Options.
setopt complete_in_word         # Complete From Both Ends Of A Word.
setopt always_to_end            # Move Cursor To The End Of A Completed Word.
setopt path_dirs                # Perform Path Search Even On Command Names With Slashes.
setopt auto_menu                # Show Completion Menu On A Successive Tab Press.
setopt auto_list                # Automatically List Choices On Ambiguous Completion.
setopt auto_param_slash         # If Completed Parameter Is A Directory, Add A Trailing Slash.
setopt no_complete_aliases

setopt menu_complete            # Do Not Autoselect The First Completion Entry.
unsetopt flow_control           # Disable Start/Stop Characters In Shell Editor.

# Zstyle.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"
# Set by LS_COLORS plugin (see below)
# zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true

# History.
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST=5000
HISTCONTROL=ignoreboth
setopt appendhistory notify
unsetopt beep nomatch

setopt bang_hist                # Treat The '!' Character Specially During Expansion.
setopt inc_append_history       # Write To The History File Immediately, Not When The Shell Exits.
setopt share_history            # Share History Between All Sessions.
setopt hist_expire_dups_first   # Expire A Duplicate Event First When Trimming History.
setopt hist_ignore_dups         # Do Not Record An Event That Was Just Recorded Again.
setopt hist_ignore_all_dups     # Delete An Old Recorded Event If A New Event Is A Duplicate.
setopt hist_find_no_dups        # Do Not Display A Previously Found Event.
setopt hist_ignore_space        # Do Not Record An Event Starting With A Space.
setopt hist_save_no_dups        # Do Not Write A Duplicate Event To The History File.
setopt hist_verify              # Do Not Execute Immediately Upon History Expansion.
setopt extended_history         # Show Timestamp In History.

# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

# Most Themes Use This Option.
setopt promptsubst

# These plugins provide many aliases - atload''
zinit wait lucid for \
        OMZ::lib/git.zsh \
        OMZ::lib/clipboard.zsh \
        OMZ::lib/directories.zsh \
    atload"unalias grv" \
        OMZ::plugins/git/git.plugin.zsh

# Provide A Simple Prompt Till The Theme Loads
PS1="READY >"
zinit ice wait'!' depth'1' lucid
zinit ice depth=1; zinit light romkatv/powerlevel10k

# # Load pure theme
# zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
# zinit light sindresorhus/pure

# # Load starship theme
# zinit ice as"command" from"gh-r" \
#           atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#           atpull"%atclone" src"init.zsh" # pull behavior same as clone, source init.zsh
# zinit light starship/starship

# - - - - - - - - - - - - - - - - - - - -
# Annexes
# - - - - - - - - - - - - - - - - - - - -

# These provide the following functionality:
#       * bin-gem-node: can create and manage executable shims
#       * submods: allows zinit to clone into submodules
#       * declare-zsh: allows CLI parsing and modification of .zshrc
# zinit light-mode for \
#     zdharma-continuum/declare-zsh
    # zinit-zsh/zinit-annex-bin-gem-node \
    # zinit-zsh/zinit-annex-submods \

# - - - - - - - - - - - - - - - - - - - -
# Plugins
# - - - - - - - - - - - - - - - - - - - -

# From https://zdharma-continuum.github.io/zinit/wiki/LS_COLORS-explanation/
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# From https://zdharma-continuum.github.io/zinit/wiki/Direnv-explanation/
zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' pick"direnv" src"zhook.zsh" for \
        direnv/direnv

zinit wait lucid light-mode for \
      OMZ::lib/compfix.zsh \
      OMZ::lib/completion.zsh \
      OMZ::lib/functions.zsh \
      OMZ::lib/diagnostics.zsh \
      OMZ::lib/git.zsh \
      OMZ::lib/grep.zsh \
      OMZ::lib/key-bindings.zsh \
      OMZ::lib/misc.zsh \
      OMZ::lib/spectrum.zsh \
      OMZ::lib/termsupport.zsh \
      OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
      OMZ::plugins/fzf/fzf.plugin.zsh \
      OMZ::plugins/safe-paste/safe-paste.plugin.zsh \
      OMZ::plugins/sudo/sudo.plugin.zsh \
      OMZ::plugins/autojump/autojump.plugin.zsh \
      OMZ::plugins/extract/extract.plugin.zsh \
      OMZ::plugins/dirhistory/dirhistory.plugin.zsh \
      OMZ::plugins/copybuffer/copybuffer.plugin.zsh \
      OMZ::plugins/taskwarrior/taskwarrior.plugin.zsh \
      OMZ::plugins/command-not-found/command-not-found.plugin.zsh \
  as"completion" \
      OMZ::plugins/systemd/systemd.plugin.zsh \
      OMZ::plugins/vi-mode/vi-mode.plugin.zsh \
      zdharma-continuum/zbrowse \
      MenkeTechnologies/zsh-tig-plugin \
      willghatch/zsh-snippets \
      robertzk/send.zsh \
      voronkovich/project.plugin.zsh \
  as"completion" \
      thuandt/zsh-pipx \
      zpm-zsh/new-file-from-template \
      horosgrisa/mysql-colorize \
  as"completion" \
      OMZ::plugins/pip/pip.plugin.zsh
      # TODO: Change sed keybinds
      # TODO: Add snippets keybinds

# TODO: Make sure histdb respects passwordless history blacklist
zinit wait lucid light-mode for \
        Aloxaf/fzf-tab \
    autoload'color; lscolor; zcolors;' \
        marlonrichert/zcolors.git \
    autoload'deer' atload"zle -N deer && bindkey '\ek' deer" \
        Vifon/deer \
        jgogstad/passwordless-history \
    nocompile \
        MenkeTechnologies/zsh-learn \
    nocompile \
        MenkeTechnologies/zsh-git-acp \
    nocompile \
        MenkeTechnologies/zsh-sed-sub

zinit wait lucid light-mode for \
    atload"bindkey -v '^R' fzf-history-widget" \
        softmoth/zsh-vim-mode \
        kazhala/dotbare \
        ianthehenry/zsh-autoquoter \
        MichaelAquilina/zsh-history-filter \
        reegnz/jq-zsh-plugin \
        caIamity/lacrimae.git \
    subst'which -> builtin which' \
        unixorn/warhol.plugin.zsh.git \
        mafredri/zsh-async \
        rupa/z \
        changyuheng/fz \
        molovo/tipz \
        mattmc3/zman \
    autoload'zsh-hints' \
        joepvd/zsh-hints




export HISTORY_FILTER_EXCLUDE=("_KEY" "Bearer" "pass add")
export ZSH_PLUGIN_GITIGNORE_TEMPLATE_PATHS="${ZDOTDIR}/gitignore_teplates:${ZSH_PLUGIN_GITIGNORE_TEMPLATE_PATHS}"

zstyle ':zsh-hints:*:' dir "${ZDOTDIR}/zsh-hints"
zstyle ':zsh-hints:*:' margin 6         # Defaults
# Use this to disable truncation of the hints-files
# zstyle ':zsh-hints:param:' verbose no
zstyle ':zsh-hints:*:' pri_sep ▶
zstyle ':zsh-hints:param:' sec_sep " "

# This has to come before syntax-highlight
zinit wait light-mode lucid for \
 blockf atinit"zicompinit; zicdreplay" \
    hlissner/zsh-autopair

zinit wait'2' light-mode lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Stores history in SQLite DB with metadata (`pwd` + datetime)
zinit wait lucid light-mode multisrc'{sqlite-history,histdb-interactive}.zsh' autoload'histdb-migrate; histdb-merge;' for \
        larkery/zsh-histdb

# _zsh_autosuggest_strategy_histdb_top_here() {
#     # Finds the most frequently-issued command issued from either
#     #   * `pwd`, or
#     #   * any subdirectory of `pwd`.
#     local query="select commands.argv from
# history left join commands on history.command_id = commands.rowid
# left join places on history.place_id = places.rowid
# where places.dir LIKE '$(sql_escape $PWD)%'
# and commands.argv LIKE '$(sql_escape $1)%'
# group by commands.argv order by count(*) desc limit 1"
#     suggestion=$(_histdb_query "$query")
# }

# _zsh_autosuggest_strategy_histdb_top() {
#     # Finds the most frequently-issued command issued from either
#     #   * exactly `pwd`, or
#     #   * any directory.
#     local query="
#         select commands.argv from history
#         left join commands on history.command_id = commands.rowid
#         left join places on history.place_id = places.rowid
#         where commands.argv LIKE '$(sql_escape $1)%'
#         group by commands.argv, places.dir
#         order by places.dir != '$(sql_escape $PWD)', count(*) desc
#         limit 1
#     "
#     suggestion=$(_histdb_query "$query")
# }

# ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

# Semi-graphical .zshrc editor for zinit commands
# zinit ice lucid wait
# zinit load zdharma-continuum/zui
zinit ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]'
zinit load zdharma-continuum/zplugin-crasis
zinit wait lucid for \
      zdharma-continuum/zui \
      z-shell/zi-console \

## MY PLUGINS
zinit wait lucid for \
  antimike/opus.plugin.zsh.git \
  antimike/wdnote.git \

zinit wait lucid light-mode as"null" multisrc'*.zsh' for \
    ${ZDOTDIR}/snippets

export ASDF_DIR=~/.asdf
zinit ice wait lucid light-mode
zinit snippet ~/.asdf/asdf.sh

zinit ice wait lucid light-mode as"completion"
zinit snippet ~/.asdf/completions/_asdf

# FZF+git keybinds
zi snippet https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh

zinit as"completion" pick"contrib/zsh_completion/_autorandr" wait lucid light-mode for \
        phillipberndt/autorandr

# export MARKER_DATA_HOME="/home/hseldon/.local/share/marker"
# zinit ice lucid wait as"program" pick"bin/marker" src"bin/marker.sh"
# zinit light antimike/marker.git

# - - - - - - - - - - - - - - - - - - - -
# User Configuration
# - - - - - - - - - - - - - - - - - - - -

setopt no_beep

# Array of command prefixes whose args will be autoquoted
export ZAQ_PREFIXES=('git commit -m' 'git commit -am')

# Load in light-mode: no reporting (this speeds up the process considerably)
zinit wait lucid light-mode for \
    multisrc'{env,alias,widgets}/*.zsh' \
        ~/.config/zsh

# - - - - - - - - - - - - - - - - - - - -
# Theme / Prompt Customization
# - - - - - - - - - - - - - - - - - - - -

# To Customize Prompt, Run `p10k configure` Or Edit `~/.p10k.zsh`.
[[ ! -f ~/.p10k.zsh ]] || . ~/.p10k.zsh

# - - - - - - - - - - - - - - - - - - - -
# End Profiling Script
# - - - - - - - - - - - - - - - - - - - -

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s')
fi

# TODO: Integrate this with FZF
# zle bindkey '^t' _histdb-isearch

config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Created by `pipx` on 2023-10-01 23:02:33
export PATH="$PATH:/home/hseldon/.local/bin"
