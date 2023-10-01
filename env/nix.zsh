#!/bin/zsh

NIX_CONFIG=~/.nix-profile/etc/profile.d/nix.sh
if [[ -e $NIX_CONFIG ]]; then
	. $NIX_CONFIG
fi	
