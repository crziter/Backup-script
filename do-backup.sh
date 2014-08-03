#!/bin/bash

# Change log:
# [*] v1.0:
#	- Load repository list from file (repos.txt)
#	- Check if git repository has modified
#	- Check if git repository has created new files
#	- Auto commit the change of repository
#	- Auto pushing to the repository's first remote if present

# [*] v1.5:
#	- Fix up some bugs
#	- Change user.email and user.name config to the global variables

# To-do:
#	- Check if files have been deleted to completely remove (do git rm --cached FILE automatic)
#	- [finish] User defined remote for pushing to (not auto choose the first one)
#	- [finish] Add usage to add-repo.sh, rm-repo.sh

script_dir=$(dirname "$0")
source "$script_dir/colors.sh"

BACKUP_VERSION="v1.5"					# Script version
DEFAULT_COMMIT_EMAIL="crziter@gmail"
DEFAULT_COMMIT_NAME="crziter"

# $1: Repo location
# $2: Repo name
repo_state=0; # Default is nothing has changed
function check_repo_state {
	echo "Checking if $2 repo has changed ...."
	cd "$1"

	# git status -sb | grep -q '[??]'
	cmd_start="git status -sb | grep -q "
	cmd_mod="$cmd_start ^' M'"
	cmd_new="$cmd_start ^??"

	eval $cmd_mod
	ret_mod=$?
	# echo "$cmd_mod returns $ret_mod"

	eval $cmd_new
	ret_new=$?
	# echo "$cmd_new returns $ret_new"

	state=0 # Nothing has changed
	if [ "$ret_mod" -eq "0" ] # Found
	then 
		state=1; # Some files have been modified
	fi

	if [ "$ret_new" -eq "0" ] # Found
	then
		if [ "$state" -eq "1" ] # Has modified value
		then
			state=3; # Some files have been created, some files have been modified
		else
			state=2; # Some files have been created
		fi
	fi

	case "$state" in
	"0") echo "Nothing has changed"
		;;
	"1") echo "Some files have been modified"
		;;
	"2") echo "Some files have been created"
		;;
	"3") echo "Some files have been modified, some files have been created"
	esac

	repo_state=$state
}

# $1: remote name
# $2: repo name
function backup_repo {
	echo "Processing add, commit, push command in $2 (remote $1)"
	git add .

	git config user.email $DEFAULT_COMMIT_EMAIL
	git config user.name $DEFAULT_COMMIT_NAME

	git commit -m "Backup repo $2 with BACKUP $BACKUP_VERSION on `date`"

	git remote | grep -q "$1"
	if [ "$?" -eq "0" ] # found
	then
		print_info "Pushing to remote: $1"
		git push --all $1
	else
		print_error "$2 has no remote to pushing"
	fi
}

# Main
arr_repo_path=()
arr_repo_name=()
arr_repo_remote=()

if [ -f "$script_dir/repos.txt" ]
then
	# Read repo list from file
	while read line
	do
		arr_repo_name+=("$(echo $line | cut -d'|' -f1)")
		arr_repo_path+=("$(echo $line | cut -d'|' -f2)")
		arr_repo_remote+=("$(echo $line | cut -d'|' -f3)")
	done < "$script_dir/repos.txt"

	print_msg $BGreen "Starting back up ${#arr_repo_name[*]} repo ..."
	for index in ${!arr_repo_name[*]}
	do
		print_info "Processing repo: ${arr_repo_name[$index]} ..."
		check_repo_state "${arr_repo_path[$index]}" "${arr_repo_name[$index]}"
		if [ "$repo_state" -ne "0" ]
		then
			backup_repo ${arr_repo_remote[$index]} ${arr_repo_name[$index]}
		else
			print_warning "Do nothing with this repo"
		fi
	done
else
	print_error "File repos.txt not found!!"
fi