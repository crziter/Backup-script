#!/bin/bash

function read_list {
	format_name='%-15s'
	format_path='%-40s'
	format_remote='%-20s'
	printf "$format_name $format_path $format_remote \n" "Repository" "Location" "Remote"

	while read line
	do
		repo_name=$(echo $line | cut -d'|' -f1)
		repo_path=$(echo $line | cut -d'|' -f2) 
		repo_remote=$(echo $line | cut -d'|' -f3) 
		printf "$format_name $format_path $format_remote \n" "$repo_name" "$repo_path" "$repo_remote"
	done < repos.txt 
}

read_list