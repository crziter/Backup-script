#!/bin/bash

source check-state.sh

function read_list {
	format_name='%-15s'
	format_path='%-35s'
	format_remote='%-10s'
	format_status='%-10s'
	printf "$format_name $format_path $format_remote $format_status \n" "Repository" "Location" "Remote" "Status"

	while read line
	do
		repo_name=$(echo $line | cut -d'|' -f1)
		repo_path=$(echo $line | cut -d'|' -f2) 
		repo_remote=$(echo $line | cut -d'|' -f3) 

		state=$(check_repo_state "$repo_path" "$repo_name")
		repo_status=""

		case $state in
		"0") repo_status="Unchange"
			;;
		*) repo_status="Changed"
			;;
		esac

		printf "$format_name $format_path $format_remote $format_status \n" "$repo_name" "$repo_path" "$repo_remote" "$state ($repo_status)"
	done < repos.txt 
}

read_list