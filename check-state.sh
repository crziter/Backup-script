#!/bin/bash

# $1: Repo location
# $2: Repo name
# repo_state=0; # Default is nothing has changed
function check_repo_state {
	# echo "Checking if $2 repo has changed ...."
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

	# case "$state" in
	# "0") echo "Nothing has changed"
	#	;;
	# "1") echo "Some files have been modified"
	#	;;
	# "2") echo "Some files have been created"
	#	;;
	# "3") echo "Some files have been modified, some files have been created"
	# esac

	# repo_state=$state
	echo $state
}