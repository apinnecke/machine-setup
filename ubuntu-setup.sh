#!/usr/bin/env bash

set -e

LISTS="$(grep -o '^[^#]*' /etc/apt/sources.list /etc/apt/sources.list.d/* | sort | uniq)"

for p in \
		graphics-drivers/ppa \
		mozillateam/firefox-next \
		ansible/ansible \
		gophers/archive \
	; do
	if [[ "${LISTS}" != *"${p}"* ]]; then
		sudo add-apt-repository -y "ppa:${p}"
	fi
done

if [ ! -f "/usr/local/bin/apt-remove-duplicate-source-entries.py" ]; then
	sudo apt install python3-apt \
		&& sudo curl -L https://raw.githubusercontent.com/davidfoerster/apt-remove-duplicate-source-entries/master/apt-remove-duplicate-source-entries.py \
			-o /usr/local/bin/apt-remove-duplicate-source-entries.py \
		&& sudo chmod +x /usr/local/bin/apt-remove-duplicate-source-entries.py
fi
sudo /usr/local/bin/apt-remove-duplicate-source-entries.py

echo "Install updates ..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Install dependencies and utilities ..."
sudo apt-get install -y \
	golang-1.9-go \
	golang-glide \
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
	ansible \
	openvpn \
	network-manager-openvpn \
	network-manager-openvpn-gnome

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
	sudo curl https://hub.github.com/standalone -Lo /usr/bin/hub \
		&& sudo chmod 755 /usr/bin/hub
fi

if ! type "kubectl" > /dev/null; then
	NAME="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
	echo "Installing kubectl ${NAME} ..."
	curl -LO "https://storage.googleapis.com/kubernetes-release/release/${NAME}/bin/linux/amd64/kubectl" \
		&& chmod +x kubectl \
		&& sudo mv kubectl /usr/local/bin/
fi

if ! type "minikube" > /dev/null; then
	echo "Installing minikube ..." \
		&& curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.0/minikube-linux-amd64 \
		&& chmod +x minikube \
		&& sudo mv minikube /usr/local/bin/
fi

if ! type "helm" > /dev/null; then
	echo "Installing helm ..." \
		&& curl -Lo helm.tgz https://storage.googleapis.com/kubernetes-helm/helm-v2.7.0-linux-amd64.tar.gz \
		&& tar -zxvf helm.tgz \
		&& chmod +x linux-amd64/helm \
		&& sudo mv linux-amd64/helm /usr/local/bin/helm \
		&& rm -r linux-amd64 helm.tgz
fi

if ! type "vivaldi" > /dev/null; then
	echo "Installing vivaldi ..." \
		&& sudo add-apt-repository 'deb http://repo.vivaldi.com/archive/deb/ stable main' \
		&& wget -qO- http://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add - \
		&& sudo apt update \
		&& sudo apt install -y vivaldi-stable
fi

if [ ! -d "$HOME/dotfiles" ]; then
	echo "Install dotfiles ..."
	git clone git@github.com:apinnecke/dotfiles.git ~/dotfiles
	pushd ~/dotfiles
	git submodule update --init
	bash ~/dotfiles/linkfiles.sh
	popd
fi

if [ "$(dpkg -l | grep spotify | wc -l)" == "0" ]; then
	echo "Install Spotify ..." \
		&& sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410 \
		&& sudo add-apt-repository "deb http://repository.spotify.com stable non-free" \
		&& sudo apt-get update \
		&& sudo apt-get install spotify-client
fi

# fucking skype does not work.   https://www.skype.com/de/download-skype/skype-for-linux/
# if ! type "skype" > /dev/null ; then
# 	echo "Installing skype ... " \
# 		&& sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" \
#  		&& sudo apt-get update \
#  		&& sudo apt-get install skype && sudo apt-get -f install
# fi

echo "Done!"
