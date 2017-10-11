#!/usr/bin/env bash

set -e

echo "Add additional apt repositories ..."
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo add-apt-repository -y ppa:mozillateam/firefox-next
sudo apt-add-repository -y ppa:ansible/ansible

echo "Install updates ..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Install dependencies and utilities ..."
sudo apt-get install -y \
	net-tools \
	ruby \
	direnv \
	firefox \
	htop \
	vim \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	"linux-image-extra-$(uname -r)" \
  linux-image-extra-virtual \
	vagrant \
	virtualbox \
	virtualbox-dkms \
	ansible

if ! type "docker" > /dev/null; then
	echo "Install Docker ..." \
		&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
		&& sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
		&& sudo apt-get update \
		&& sudo apt-get install -y \
			docker-ce \
		&& docker --version
fi

if ! type "docker-compose" > /dev/null; then
	echo "Install docker-compose ..." \
		&& sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` \
			-o /usr/local/bin/docker-compose \
		&& sudo chmod +x /usr/local/bin/docker-compose \
		&& docker-compose --version
fi

if ! type "code" > /dev/null; then
	echo "Install VScode ..." \
		&& curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
		&& sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
		&& sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
		&& sudo apt-get update \
		&& sudo apt-get install -y code
fi

if ! type "atom" > /dev/null; then
	echo "Install Atom ..." \
		&& sudo add-apt-repository -y ppa:webupd8team/atom \
		&& sudo apt update \
		&& sudo apt-get install -y atom
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
	echo "Setup ssh keys ..."
	mkdir -p -m 0644 "$HOME/.ssh"
	vim "$HOME/.ssh/id_rsa"
	vim "$HOME/.ssh/id_rsa.pub"
fi

if ! type "hub" > /dev/null; then
	sudo curl https://hub.github.com/standalone -Lo /usr/bin/hub
	sudo chmod 755 /usr/bin/hub
fi

if [ ! -d "$HOME/dotfiles" ]; then
	echo "Install dotfiles ..."
	git clone git@github.com:apinnecke/dotfiles.git ~/dotfiles
	pushd ~/dotfiles
	git submodule update --init
	bash ~/dotfiles/linkfiles.sh
	popd
fi

echo "Done!"
