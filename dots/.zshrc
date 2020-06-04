### zsh ###

export ZSH="/Users/tom/.oh-my-zsh"

ZSH_THEME="gozilla"

#For full path in theme, change the '%c' in PROMPT to '%d' (full path) or '%~' (home dir replaced by ~)

plugins=(
	git
	nvm
)

source $ZSH/oh-my-zsh.sh



### nvm ###

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion



### git autocompletion ###

__get_all_git_aliases ()
{
	local section="$1" i IFS=$'\n'
	for i in $(git config --get-regexp ^alias\. | sed -e s/^alias\.// -e 's/ .*//'); do
		echo "${i#$section.}"
	done
}

for al in `__get_all_git_aliases`; do
    alias g$al="git $al"
done



### posh git terminal ###

. ~/git/util/posh-git-sh/git-prompt.sh
RPROMPT='$(__posh_git_echo)'



### projects ###

. ~/.projects/dotfiles
. ~/.projects/century21