#!/bin/bash

script_dir=$(dirname "$0")
source "$script_dir/colors.sh"

BACKUP_VERSION="v1.0"

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

# $1: Repo location
# $2: Repo name
function backup_repo {
	echo "Processing add, commit, push command in `pwd`"
	git add .

	git config user.email "crziter@gmail.com"
	git config user.name "crziter"

	git commit -m "Backup repo $2 with BACKUP $BACKUP_VERSION on `date`"

	num_lines=$(git remote | wc -l)
	if [ "$num_lines" -gt "0" ]
	then
		remote=$(git remote | head -1 | tail -1)
		print_info "Pushing to remote: $remote"

		git push --all $remote
	else
		print_error "$2 has no remote to pushing"
	fi
}

# Main
arr_repo_path=()
arr_repo_name=()

# Read repo list from file
while read line
do
	arr_repo_name+=("$(echo $line | cut -d'|' -f1)")
	arr_repo_path+=("$(echo $line | cut -d'|' -f2)")
done < repos.txt

print_msg $BGreen "Starting back up ${#arr_repo_name[*]} repo ..."
for index in ${!arr_repo_name[*]}
do
	print_info "Processing repo: ${arr_repo_name[$index]} ..."
	check_repo_state "${arr_repo_path[$index]}" "${arr_repo_name[$index]}"
	if [ "$repo_state" -ne "0" ]
	then
		backup_repo
	else
		print_warning "Do nothing with this repo"
	fi
done
