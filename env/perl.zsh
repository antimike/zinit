#!/bin/zsh
# Output of `perl -I ~/perl5/lib/perl5/ -Mlocal::lib=~/perl5`

PATH="/home/hactar/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/hactar/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/hactar/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/hactar/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/hactar/perl5"; export PERL_MM_OPT;
