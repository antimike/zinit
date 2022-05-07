#!/bin/zsh
# Config for overcommit (git hooks manager)
# https://github.com/sds/overcommit

export GIT_TEMPLATE_DIR="$(overcommit --template-dir)"
export GIT_EDITOR='nvr -cc split --remote-wait'
