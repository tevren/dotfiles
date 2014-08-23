#!/usr/bin/env bash

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "install_homebrew" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
	~/.osx
	~/.brew
	~/.caskfile
	source ~/.zshrc
}

read -p "This will do the following \
(1) Install homebrew \
(2) Install .dotfiles \
(3) Install various brews \
(4) Install various casks \
WARNING: This process takes forever! If you choose to continue, then go grab some coffee. OK? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	# Ask for the administrator password upfront
	sudo -v
	# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
	ruby -e "$(curl -fsSL https://raw.github.com/tevren/dotfiles/master/install_homebrew)"
	git clone https://www.github.com/tevren/dotfiles.git /tmp/dotfiles
	cd "/tmp/dotfiles"
	git pull origin master
	if [ "$1" == "--force" -o "$1" == "-f" ]; then
		doIt
	else
		read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
		echo
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			doIt
		fi
	fi
	unset doIt
	# install oh-my-zsh if it isnt installed
	if [[ -d ".oh-my-zsh"]]
	else
		curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
		chsh -s /usr/local/bin/zsh
	fi
	rm -rf /tmp/dotfiles
	for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail" \
	"Messages" "Safari" "SizeUp" "SystemUIServer" "Transmission" "iCal"; do
	killall "${app}" > /dev/null 2>&1
	done
	echo "Done. Note that some of these changes require a logout/restart to take effect."
fi

