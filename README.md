Backup-script is a utility which help you backing up git repositories in one line of command

# Install
1. Clone the repository


	```bash
	git clone https://github.com/crziter/Backup-script.git
	```

2. Fix permission (if necessary)

	```bash
	chmod +x do-backup.sh
	chmod +x add-repo.sh
	chmod +x rm-repo.sh
	chmod +x ls-repo.sh
	```

3. Add repo to library


	```bash
	./add-repo.sh "Repo name" "/repo/location"
	```

4. Do backup every time you need


	```bash
	./do-backup-sh
	```

5. Fork and do-every-thing-you-want
