### zsh ###

export ZSH="/Users/tom/.oh-my-zsh"

ZSH_THEME="gozilla" # For full path in prompt, go to theme file and change the '%c' in PROMPT to '%d' (full path) or '%~' (home dir replaced by ~)

plugins=(
	git
	nvm
)

source $ZSH/oh-my-zsh.sh

alias .z=". ~/.zshrc"
alias .zsh=". ~/.zshrc"
alias .zshrc=". ~/.zshrc"

### skhd ###

# find process that enabled secure input, which causes the `skhd` command to fail:
# ioreg -l -w 0 | perl -nle 'print $1 if /"kCGSSessionSecureInputPID"=(\d+)/' | uniq | xargs -I{} ps -p {} -o comm=
# if login screen -> lock pc, log in through providing password instead of fingerprint

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


### autocompletion ###

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
source /usr/local/etc/bash_completion.d/az


### projects ###

alias .init=". ./bin/init"

. ~/.projects/dotfiles
#. ~/.projects/jnj
# . ~/.projects/century21
. ~/.projects/dgp
