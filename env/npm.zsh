#!/bin/zsh
# Setup environment variables to allow global NPM installs without sudo

export NPM_INSTALL_PREFIX=${NPM_INSTALL_PREFIX:-$HOME/.npm-packages}

export PATH="$PATH:$NPM_INSTALL_PREFIX/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_INSTALL_PREFIX/share/man"
