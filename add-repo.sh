#!/bin/bash

# $1: repo name
# $2: repo location

function print_usage {
	printf "Usage: $0 repo_name /path/to/repo remote\n"
}

if [ "$#" -ne 3 ]
then
	print_usage
else
	echo "$1|$2|$3" >> repos.txt
	echo "Repo $1 has been added to library"
fi