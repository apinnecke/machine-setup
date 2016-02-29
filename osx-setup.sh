#!/bin/bash

open "http://dropbox.com/downloading?src=index"
open "https://pqrs.org/osx/karabiner/"
open "https://www.iterm2.com/downloads.html"
open "https://www.spotify.com/de/download/"
open "https://github.com/stonesam92/ChitChat/releases/latest"
open "https://itunes.apple.com/de/app/1password/id443987910?mt=12#"

defaults write com.apple.finder AppleShowAllFiles YES

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install git hub
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
