# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/zerg/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# config prompt
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_HIDE_IF_PWD_IGNORED=1
setopt PROMPT_SUBST ; PS1='%B%F{blue}%~%f%F{yellow}$(__git_ps1 " git:(%s)") %f%%%b '

# load aliases
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

if [ -e ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
	source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
