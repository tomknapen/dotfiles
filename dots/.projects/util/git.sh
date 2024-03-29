### git autocompletion ###

__get_all_git_aliases ()
{
	local section="$1" i IFS=$'\n'
	for i in $(git config --get-regexp ^alias\. | sed -e s/^alias\.// -e 's/ .*//'); do
		echo "${i#$section.}"
	done
}

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

	JIRA=$(curl --location --request GET ${TICKET_URL} --header $JIRA_XPLORE_AUTH_HEADER)
	
	# get ticket information from JIRA response
	JIRA_SUMMARY=$(echo "$JIRA"| tr '\r\n' ' ' | jq -r '.fields.summary')
	JIRA_KEY=$(echo "$JIRA"| tr '\r\n' ' ' | jq -r '.key')

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

$(echo $@)";
	fi

	# add all changes and commit with the auto generated message
	git add -A && git commit -m "$COMMIT_MESSAGE"
}

for al in `__get_all_git_aliases`; do
    alias g$al="git $al"
done

alias gc=__git_commit_with_auto_message


### posh git terminal ###

. ~/git/util/posh-git-sh/git-prompt.sh
RPROMPT='$(__posh_git_echo)'