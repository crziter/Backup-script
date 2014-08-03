#!/bin/bash
# $1: repo name

found=0
while read line
do
	repo_name=$(echo $line | cut -d'|' -f1)
	if [ "$repo_name" == "$1" ]
	then
		found=1
	else
		echo $line >> repos.tmp
	fi
done < repos.txt

if [ $found -eq 1 ] # Found repo
then
	rm repos.txt

	if [ -f "repos.tmp" ]
	then
		mv repos.tmp repos.txt
	else
		touch repos.txt
	fi

	echo "Repo $1 is removed"
else
	rm repos.tmp
	echo "Repo $1 not found"
fi