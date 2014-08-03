#!/bin/bash

function read_list {
	format_name='%-20s'
	format_path='%-30s'
	printf "$format_name $format_path \n" "Repository" "Location"

	while read line
	do
		repo_name=$(echo $line | cut -d'|' -f1)
		repo_path=$(echo $line | cut -d'|' -f2) 
		printf "$format_name $format_path \n" "$repo_name" "$repo_path"
	done < repos.txt 
}

read_list