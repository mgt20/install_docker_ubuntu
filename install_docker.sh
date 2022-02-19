#!/bin/bash

remove_docker() {
	echo "removing docker"
	sudo apt-get remove docker docker-engine docker.io containerd runc
}

install_dependencies() {
	echo "installing dependencies"
	sudo apt-get update
	sudo apt-get install \
	    ca-certificates \
	    curl \
	    gnupg \
	    lsb-release
}

add_gpg_key() {
	echo "adding gpg key"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg #TODO make this command work on subsequent runs without user interaction
}

add_stable_repo() {
	echo "adding docker stable repo"
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

install_docker_engine() {
	echo "installing docker engine"
	sudo apt-get update
	sudo apt-get install \
		docker-ce \
		docker-ce-cli \
		containerd.io
}

setup_user() {
	echo "setting up user"
	getent group docker || groupadd docker
	echo "added group"
	sudo usermod -aG docker $USER
	echo "added user to group"
	#TODO add newgrp docker command without errors somehow

}

start_on_boot() {
	echo "configuring docker to start on boot"
	sudo systemctl enable docker.service
	sudo systemctl enable containerd.service
}

setup_compose() {
	echo "installing docker compose"
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version
}

remove_docker
install_dependencies
add_gpg_key
add_stable_repo
install_docker_engine
setup_user
start_on_boot
setup_compose
