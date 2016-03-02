#!/bin/bash

open "http://dropbox.com/downloading?src=index"
open "https://itunes.apple.com/de/app/wunderlist-to-do-liste/id410628904?mt=12"

defaults write com.apple.finder AppleShowAllFiles YES

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install \
	git hub git-flow ack htop-osx awscli node bash-completion lynx \
	nvm terraform mcrypt thefuck ffind tree clang-format otto wget

brew cask install \
	iterm2 1password chitchat karabiner seil google-chrome firefox opera atom \
	caffeine evernote flycut lastfm skype slack spotify spotify-notifications \
	sublime-text vagrant vagrant-manager virtualbox vlc viscosity screenhero

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

# create src dir and
sudo mkdir -p /src/apinnecke
sudo chown -R apinnecke:admin /src

# install osx-setup
git clone apinnecke/osx-setup /src/apinnecke/osx-setup
brew install $(cat /src/apinnecke/osx-setup/brew-packages)
brew cask install $(cat /src/apinnecke/osx-setup/brew-cask-packages)
