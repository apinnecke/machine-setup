#!/bin/bash

open "https://www.dropbox.com/downloading?src=index"
open "https://itunes.apple.com/de/app/wunderlist-to-do-liste/id410628904?mt=12"
open "https://docs.docker.com/docker-for-mac/"
open "https://www.jetbrains.com/webstorm/download/"

defaults write com.apple.finder AppleShowAllFiles YES

curl -sSL https://get.rvm.io | bash
rvm install ruby-2.3.0

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew tap homebrew/completions
brew tap homebrew/php
brew tap wercker/wercker

brew install \
	python git hub git-flow ack htop-osx awscli bash-completion lynx \
	nvm terraform mcrypt thefuck ffind tree clang-format wget lame \
	boris composer bash-completion wercker-cli awscli terraform tldr \
	kubernetes-helm kubernetes-cli kops watch shyaml awscli git-crypt gpg-agent
	

brew cask install \
	iterm2 1password whatsapp karabiner seil google-chrome firefox opera atom \
	caffeine evernote flycut lastfm skype slack spotify spotify-notifications \
	sublime-text vagrant vagrant-manager virtualbox vlc viscosity java spectacle \
	mysqlworkbench sequel-pro psequel tuxguitar usb-overdrive wireshark valentina-studio \
	xccello

pip install --upgrade git-up

sudo gem install git-up
echo 'require_confirmation = False' >> ~/.config/thefuck/settings.py
alias git="hub"

vi install_dropbox_and_docker_and_wait_for_sync # exit with :q! when dropbox and docker are installed

bash Dropbox/Configs/karabiner-import.sh

# install ssh key files
cp ~/Dropbox/ssh.zip ~/
unzip ~/ssh.zip
chmod 0600 ~/.ssh/id_*

# install dotfiles
git clone git@github.com:apinnecke/dotfiles.git ~/dotfiles
cd ~/dotfiles && git submodule update --init
bash ~/dotfiles/linkfiles.sh

# install docker bash completion
pushd /usr/local/etc/bash_completion.d
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion  
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion  
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion  
popd

apm install --packages-file ~/dotfiles/atom-package-list.txt || echo "Installing apm packages failed"

# create source dir files, use go structure
mkdir -p ~/src/github.com ~/pkg ~/bin
