# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_HIDE_IF_PWD_IGNORED=1
GIT_PS1_SHOWUNTRACKEDFILES=1
setopt PROMPT_SUBST
PS1='%B%F{blue}%~%f%F{yellow}$(__git_ps1 " (%s)") %f%%%b '

if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

if [ -e ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
	source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

export MANPAGER='nvim +Man!'
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.opencode/bin
