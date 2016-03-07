#!/bin/bash

open "http://dropbox.com/downloading?src=index"
open "https://itunes.apple.com/de/app/wunderlist-to-do-liste/id410628904?mt=12"

defaults write com.apple.finder AppleShowAllFiles YES

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install \
	ruby git hub git-flow ack htop-osx awscli node bash-completion lynx \
	nvm terraform mcrypt thefuck ffind tree clang-format otto wget \
	docker docker-compose docker-machine

brew cask install \
	iterm2 1password chitchat karabiner seil google-chrome firefox opera atom \
	caffeine evernote flycut lastfm skype slack spotify spotify-notifications \
	sublime-text vagrant vagrant-manager virtualbox vlc viscosity screenhero \
	java hyperdock

gem install git-up

sudo gem install git-up
echo 'require_confirmation = False' >> ~/.config/thefuck/settings.py
alias git="hub"

vi install_dropbox_and_wait_for_sync # exit with :q! when dropbox is installed

bash Dropbox/Configs/karabiner-import.sh

# install ssh key files
cp ~/Dropbox/ssh.zip ~/
unzip ~/ssh.zip
chmod 0600 ~/.ssh/id_*

# install dotfiles
git clone apinnecke/dotfiles ~/dotfiles
cd ~/dotfiles && git submodule update --init
bash ~/dotfiles/linkfiles.sh

# create src dir
sudo mkdir -p /src
sudo chown -R apinnecke:admin /src

sudo npm install -g gulp-cli pm2 typings
