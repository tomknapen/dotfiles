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

### git utils ###

__git_commit_with_auto_message ()
{
	#get current git branch
	CURRENT_BRANCH=$(git branch --show-current)

	#get branch type and issue number from current branch
	regex="(.+)/(.+)";
	[[ "$CURRENT_BRANCH" =~ $regex ]]
	TYPE="${match[1]}"
	TICKET_NUMBER="${match[2]}"

	# if no ticket number found, report and abort
	if [ -z "$TICKET_NUMBER" ]; 
		then 
			echo "Could not create an auto message: could not determine JIRA ticket number. Aborting."
			return;
	fi

	# call the JIRA REST API
	# jira api token kjIiso2CTlaAbXXggROF6AEC
	# jira basic auto token command: echo -n tom.knapen@two-point-o.be:kjIiso2CTlaAbXXggROF6AEC | base64
	TICKET_URL="https://xploregroup.atlassian.net/rest/api/latest/issue/${TICKET_NUMBER}"
	JIRA=$(curl --location --request GET ${TICKET_URL} \
	--header 'Authorization: Basic dG9tLmtuYXBlbkB0d28tcG9pbnQtby5iZTpraklpc28yQ1RsYUFiWFhnZ1JPRjZBRUM=')
	
	# get ticket information from JIRA response
	JIRA_SUMMARY=$(echo "$JIRA" | jq -r '.fields.summary')
	JIRA_KEY=$(echo "$JIRA" | jq -r '.key')

	# if no data could be fetched, report and abort
	if [ -z "$TICKET_NUMBER" ]; 
		then 
			echo "Could not create an auto message: could not get data from JIRA. Aborting."
			return;
	fi

	# build the commit message
	COMMIT_MESSAGE="{$TYPE} $JIRA_SUMMARY [$JIRA_KEY]"

	# if extra info was passed, put it underneath the autogenerated message
	if [ $1 ]
		then COMMIT_MESSAGE="$COMMIT_MESSAGE  

$1";
	fi

	# add all changes and commit with the auto generated message
	git add -A && git commit -m "$COMMIT_MESSAGE"
}

alias gc=__git_commit_with_auto_message


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
# . ~/.projects/jnj
# . ~/.projects/century21
# . ~/.projects/dgp
