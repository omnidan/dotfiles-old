# Based off Mkaysi's zshrc in Mkaysi/shell-things - thanks a lot!

# TOC
#   Defaults                    M0TZLS
#   Environment                 7RS56S
#   Aliases                     RJ706I
#   Functions                   ZGC5QQ
#   Tmux (example)              4G2W9C

#####   Defaults                M0TZLS  #####

# This is based on zshrc which came with Debian (Third option in wizard for new users.)

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
# has current branch unrecorded changes?
# http://markelikalderon.com/2009/01/16/dirty-prompts/
parse_git_dirty() {
  git diff --quiet HEAD &>/dev/null
  [[ $? == 1 ]] && echo "*"
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function pre_spacing() {
  echo "%B%(!.%F{red}.%F{green})%n@%m %~"
}

function time_info() {
  echo "$(date +%H:%M:%S)"
}

#function put_spacing() {
#  # Git stuff
#  local git=$(git_prompt_info)
#  if [ ${#git} != 0 ]; then
#    ((git=${#git} - 10))
#  else
#    git=0
#  fi
#  
#  local termwidth
#  (( termwidth = ${COLUMNS} - ${#$(pre_spacing)} - ${git}))
#  local spacing=""
#  for i in {1..$termwidth}; do
#    spacing="${spacing} "
#  done
#  echo $spacing
#}

function precmd() {
print -rP "$(pre_spacing)   $(git_prompt_info) [$(time_info)]"
}


# Set up the prompt

autoload -Uz promptinit
# Green for normal user and red for root. Thanks nyuszika7h :D
promptinit
#PS1="%B%(!.%F{red}.%F{green})%n@%m %~
PS1="%B%(!.%F{red}.%F{green})%#%f%b "

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# From holman's dotfiles, thank you!
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

#####   Environment                 7RS56S  #####
# Environment should be placed to .environment or .zsh_environment (or .zshenv).

# Source before mentioned locations if they exist.

# .environment
if [ -f ~/.environment ]; then
    source ~/.environment
fi

# .zsh_environment
if [ -f ~/.zsh_environment ]; then
    source ~/.zsh_environment
fi

# .zshenv (Yes, I know that this is sourced by every zsh session even if this isn't here, but I just want to write it).
if [ -f ~/.zshenv ]; then
    source ~/.zshenv
fi

#More colours :D
if [[ $TERM == 'xterm' ]]; then
export TERM=xterm-256color
fi

if [[ $TERM == 'screen' ]]; then             
export TERM=screen-256color              
fi

# Things after this are just examples and should be put to some other file, which is sourced above.

# Sets the default editor. I am vim user, so I want it to be vim. If you don't like terminal based text editors, change "vim" to gedit (Gnome) or Kate (KDE).
export EDITOR=vim

# Sets user specific PYTHONPATH. Replace 2.X with your Python version. For example with Python 2.7 you replace X with 7.
#export PYTHONPATH=$HOME/.packages/lib/python2.X/site-packages

# Sets locale. You can get a list of locales with "locale -a" command.
#export LC_ALL=en_UK.utf8

# Sets your timezone. Set in format <Region/City>, or just timezone like UTC.
export TZ="/usr/share/zoneinfo/Europe/Vienna"

# Sets PATH. To add another path, add :</path/to/new/path> to string below. 
# Additional path variable
PATH=$PATH:/home/dan/apps/bin

# Sets web-browser.
export BROWSER=firefox

# "Changes" home directory without root. Uncomment both lines below this.
#export HOME=<path to new home>
#cd

# Uses most as the default pager if you uncomment line below. (You will also get colourful manpages :D).
export PAGER=most

#####   Aliases                     RJ706I  #####

# todo alias
alias todo="grep -r 'TODO\|FIXME' ."

# To get sudo to work with aliases.
alias sudo="sudo "

# Moving between directories:
alias ..="cd .."
alias .="cd ."

# Automaticly adds title to Youtube-dl when downloading videos with it. Requires youtube-dl.
#alias youtube-dl="youtube-dl -t"

# git specific. This is the command which I use when git asks me to commit something and says that I have modified files, even when I haven't.
alias gdrop="git stash && git stash drop"
#alias gitk="gitg" # Requires gitg . I just think that it looks nicer than gitk.

# Usually when I run "time", I want to know the current time.
#alias time="date"

# If I run nautilus, I want it to open in folder where I am.
alias nautilus="nautilus ./"

# Same goes with dolphin
alias dolphin="dolphin ./"

# Why I must write "weechat-curses" to start it?
alias weechat="weechat-curses"

#NMAP specific. All nmap things should be run as root, so it's probably best to copy these aliases to root's .zshrc. Things which don't run without root ask for sudo password.
alias nmap-intense="nmap -T4 -A -v -PE -PS22,25,80 -PA21,23,80,3389 "
alias nmap-intense-udp="sudo nmap -sS -sU -T4 -A -v -PE -PS22,25,80 -PA21,23,80,3389 "
alias nmap-intense-all-tcp="nmap -p 1-65535 -T4 -A -v -PE -PS22,25,80 -PA21,23,80,3389 "
alias nmap-intense-no-ping="nmap -T4 -A -v -PN "
alias nmap-ping="nmap -sP -PE -PA21,23,80,3389 "
alias nmap-quick="nmap -T4 -F "
alias nmap-quick-plus="sudo nmap -sV -T4 -O -F --version-light "
alias nmap-traceroute="sudo nmap -sP -PE -PS22,25,80 -PA21,23,80,3389 -PU -PO --traceroute "
alias nmap-regular="nmap "
alias nmap-comprehensive="sudo nmap -sS -sU -T4 -A -v -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PO --script all " 
# Little "safer" scan as connecting to only HTTP and HTTPS ports doesn't look so attacking. Copy-paste to .zsh_custom and remove  " -p 80,443" if you want to scan all ports which nmap scans by default.
alias nmap-osscan="sudo nmap -p 80,443 -O -v --osscan-guess --fuzzy "
#alias ping="nping "
#alias ping6="nping -6"
#alias netcat="ncat "

# TOR (The Onion Router) specific.
alias usewithtor="proxychains "
alias torsocks="proxychains "

# This should allow aliases to work with proxychains.
alias proxychains="proxychains "

# Downloads folder over SSH. Usage: rdownload <host>:<remotefolder> <local_destination> | TIP: use ~/ssh/config to configure hosts.
alias rdownload="rsync -h --progress -avz "

# TMUX specific
alias attach="exec tmux -u attach-session"
alias detach="tmux -u detach"
alias tmux="exec tmux -2 -u"

# lsd alias
alias lsd="echo 'What? I have no drugs for you. Oh, you meant ls, here you go.'; ls"

# I am always typoing "aptitude" with my phone...
alias aptitute="aptitude "

# This is the checkinstall rule which I like to use.
#alias checkinstall="make install "

# The Battle for Wesnoth specific, http://wesnoth.org/
# It seems to be an good idea to have debug logs on terminal with svn version.
alias wesnoth="wesnoth --debug"

# Auto extension things, ( modified from https://wiki.archlinux.org/index.php/Zsh#Advanced_.zshrc_files )
alias -s html=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s png="feh"
alias -s jpg="feh"
alias -s gif="feh"
alias -s sxw="libreoffice --writer"
alias -s doc="libreoffice --writer"
alias -s gz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s java=$EDITOR
alias -s txt=$EDITOR
alias -s PKGBUILD=$EDITOR

# For copy-pasting directly from somewhere
alias %=" "

# SupyBot specifig. Why to write long command, if you can write short command?
alias supybot-config-reload="killall -HUP supybot "
alias supybot-owner-quit="killall -INT supybot "
# Translating plugins in Limnoria
alias supybot-generate-messages.pot="pygettext −−docstrings config.py plugin.py"
alias supybot-generate-messages.pot-xgettext="xgettext --language=Python config.py plugin.py && mv -f messages.po messages.pot"

# ZSH specific.
# I think that "theme" is more describing than "prompt".
alias theme="prompt "

## -- Start of aliases which are saved from Ubuntu default bashrc. --

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# Add an "alert" alias for long running commands.  Use like so:
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
                        
## -- End of aliases which are saved from Ubuntu default bashrc. --

# Copying command in Supybot (Internet.DNS)
alias dns="nslookup "
alias dns6="nslookup -type=AAAA "
alias nslookup6="nslookup -type=AAAA "

# If I have nslookup6...
alias dig6="dig AAAA "

# SSHGuard specific
alias sshguard-show-bans="sudo iptables -L sshguard --line-numbers"
# Enter ban number as arguement. You can see ban numbers with previous command.
alias sshguard-unban="sudo iptables -D sshguard "

# This needs something which makes it easy to remember.
alias KILL="killall -KILL "

# For locally rsync copying folder1 to folder2.
alias rsync-folder="rsync -h --progress -azvv "

# SSHGuard seems to prefer users to run this always when connecting with keys in ssh-agent...
alias ssh-add="\ssh-add -D && \ssh-add "

# Usually aptitude is installed everywhere and if it's not, it can be unaliased in .aliases.
#alias apt-get=aptitude

# Allow custom aliases to be put in .aliases or .zsh_aliases .

# .aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# .zsh_aliases
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

#####   Functions                   ZGC5QQ  #####

# GEOIP lookup, copied from the ultimate bashrc http://goo.gl/qGK5j
function geoip() {
geoiplookup $1
}

# MYIP, copied from the ultimate bashrc http://goo.gl/qGK5j . I think that it requires lynx.
function myip()
{
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
}

# Checks which package the command comes from. Copied from the ultimate bashrc http://goo.gl/qGK5j
function cmdpkg() { PACKAGE=$(dpkg -S $(which $1) | cut -d':' -f1); echo "[${PACKAGE}]"; dpkg -s "${PACKAGE}" ;}

# ROT13, copied from the ultimate bashrc http://goo.gl/qGK5j
function rot13()
{
    if [ $# -lt 1 ] || [ $# -gt 1 ]; then
        echo "Seriously?  You don't know what rot13 does?"
    else
        echo $@ | tr A-Za-z N-ZA-Mn-za-m
    fi
}

# Down for everyone or just me? Copied from the ultimate bashrc http://goo.gl/qGK5j
function downforme() {
	RED='\e[1;31m'
	GREEN='\e[1;32m'
	YELLOW='\e[1;33m'
	NC='\e[0m'
	if [ $# = 0 ]
	then
		echo -e "${YELLOW}usage:${NC} downforme website_url"
	else
		JUSTYOUARRAY=(`lynx -dump http://downforeveryoneorjustme.com/$1 | grep -o "It's just you"`)
		if [ ${#JUSTYOUARRAY} != 0 ]
		then
			echo -e "${RED}It's just you. \n${NC}$1 is up."
		else
			echo -e "${GREEN}It's not just you! \n${NC}$1 looks down from here."
		fi
	fi
}

# Topt10 commands, copied from the ultimate bashrc http://goo.gl/qGK5j
function top10() {
	# copyright 2007 - 2010 Christopher Bratusek
	history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# ex command. Copied from zshrc of bioterror ( http://ricecows.org/configs/zsh/.zshrc ). Original comment below:
## for unit193 ;)
## use command "ex" to extract any archive files.
## "ex package.zip" for example
function ex ()

{
if [ -f "$1" ] ; then
case "$1" in
      *.tar)                tar xvf $1          ;;
      *.tar.bz2 | *.tbz2 )  tar xjvf $1         ;;
      *.tar.gz | *.tgz )    tar xzvf $1         ;;
      *.bz2)                bunzip2 $1          ;;
      *.rar)                unrar x $1          ;;
      *.gz)                 gunzip $1           ;;
      *.zip)                unzip $1            ;;
      *.Z)                  uncompress $1       ;;
      *.7z)                 7z x $1             ;;
      *.xz)                 tar xJvf $1         ;;
      *.deb)
         DIR=${1%%_*.deb}
         ar xv $1
         mkdir ${DIR}
         tar -C ${DIR} -xzvf data.tar.gz        ;;
      *.rpm)               rpm2cpio $1 | cpio -vid  ;;
      *)   echo ""${1}" cannot be extracted via extract()"
;;
    esac
   else
    echo ""${1}" is not a valid file"
fi
}

# Given by nyuszika7h. Shortens GitHub URLs with git.io
gitio () {
        curl -s -i http://git.io -F "url=$1" | grep
                --color=never -P '^Location: ' | awk '{ print $2 }'
                        }

#####   Tmux (example)              4G2W9C  #####

# This should be put in .custom or .zsh_custom

# Starts tmux on SSH login. (From http://william.shallum.net/random-notes/automatically-start-tmux-on-ssh-login )
#TIP: replace "0" with name of computer if you don't ever have direct (without SSH) access to computer where zsh is running on.

#if [ "$PS1" != "" -a "${STARTED_TMUX:-x}" = x -a "${SSH_TTY:-x}" != x ]
#then
#        STARTED_TMUX=1; export STARTED_TMUX
#        sleep 1
#        ( (\tmux has-session -t 0 && \tmux attach-session -t 0) || (\tmux new-session -s 0) ) && exit 0
#        echo "tmux failed to start"
#fi

# Source files for miscannellious modifications.

# .custom
if [ -f ~/.custom ]; then
    source ~/.custom
    fi

# .zsh_custom
if [ -f ~/.zsh_custom ]; then
    source ~/.zsh_custom
    fi
