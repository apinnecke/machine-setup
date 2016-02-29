#!/bin/bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install $(cat brew-packages)

# install dotfiles
cd ~
git clone apinnecke/dotfiles
bash dotfiles/linkfiles.sh
