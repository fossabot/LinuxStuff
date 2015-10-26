alias ll="ls -l"
alias lo="ls -o"
alias lh="ls -lh"
alias la="ls -la"
alias powersave="sudo cpupower frequency-set -g powersave"
alias ondemand="sudo cpupower frequency-set -g ondemand"

shopt -s histappend
# Combine multiline commands into one in history
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups

noerr() { # execute the last command while redirecting errors
    if [[ $# == 0 ]]; then
	$(history -p '!!') 2>/dev/null
    fi
}

fuck() { # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
	sudo $(history -p '!!')
    else
	sudo "$@"
    fi
}

ex () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

# Setup items
bash_head=~/.bash_head
if [ -f $bash_head ]; then
    . $bash_head
fi

# ===== BASH Color Escape Sequences =====
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[10;95m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

off=$Color_Off

# ===== The standard PS1 =====
user_color=$Blue
host_color=$Red
path_color=$Cyan
prompt_symbol=\$
if [[ $SPECIAL_CHARACTERS == true ]]; then
   prompt_symbol=?
fi

if [ `id -u` -eq 0 ]; then
    # Swap colors if we are root
    temp_color=$user_color
    user_color=$host_color
    host_color=$temp_color
    prompt_symbol=\#
fi

BASE_PS1="\
\[$off\]\
\[$user_color\]\u\
\[$off\]@\
\[$host_color\]\h\
\[$off\]:\
\[$path_color\]\w\
\[$off\]$prompt_symbol "

export PS1="${BASE_PS1}"

#a -- black
#b -- red
#c -- green
#d -- brown
#e -- blue
#f -- magenta
#g -- cyan
#h -- light gray
#A -- bold black, usually shows up as dark gray
#B -- bold red
#C -- bold green
#D -- bold brown, usually shows up as yellow
#E -- bold blue
#F -- bold magenta
#G -- bold cyan
#H -- bold light gray; looks like bright white
#x -- default foreground or background

#DIR=Ex
#SYM_LINK=Gx
#SOCKET=Fx
#PIPE=dx
#EXE=Cx
#BLOCK_SP=Dx
#CHAR_SP=Dx
#EXE_SUID=hb
#EXE_GUID=ad
#DIR_STICKY=Ex
#DIR_WO_STICKY=Ex

#export LSCOLORS=GxFxCxDxBxegedabagaced # BSD/OSX
export LS_COLORS=GxFxCxDxBxegedabagaced # Linux
export CLICOLOR=1

ls_color=""
# ===== Aliases =====
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    ls_color=" --color=auto"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls aliases
alias ls="ls${ls_color} -p"
alias ll="ls${ls_color} -l"
alias la="ls${ls_color} -a"
alias lstree="tree -if --noreport"


# ===== History Configurations =====
HISTSIZE=10000
HISTFILESIZE=10000000000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%D - %T : "
shopt -s histappend
shopt -s checkwinsize

home_bin=~/bin
if [ -x $home_bin ]; then
    PATH=$PATH:$home_bin
fi
home_rbin=~/rbin
if [ -x $home_rbin ]; then
    PATH=$home_rbin:$PATH
fi
export PATH

python_lib=~/lib/python
if [ -x $python_lib ]; then
    PYTHONPATH=$python_lib:$PYTHONPATH
fi
export PYTHONPATH

export EDITOR=vim
export VISUAL=view
export GIT_SSH=`which ssh`

# Don't dump cores larger than this
ulimit -c 500000000 # 500 MB

# User-only writes
umask 0022

# Vi key-bindings for shell (default is emacs)
set -o vi


# ====================================
# gitprompt configuration

# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=1

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch

# GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

# as last entry source the gitprompt script
# GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
source ~/git/bash-git-prompt/gitprompt.sh
