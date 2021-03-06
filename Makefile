.PHONY: all test clean help

help:                                                      ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##
up_fuseki: create_vm install_docker                        ## Start Fuseki test environment

create_vm:                                                 ## Create a basic virtual machine
	vagrant up vm-fuseki

install_docker:                                            ## Load the docker components
	vagrant ssh vm-fuseki -c "curl -sSL https://get.docker.com/ubuntu/ | sudo sh"

build:                                                     ## Build the docker image from the Dockerfile
	vagrant ssh vm-fuseki -c "sudo docker build -t brinxmat/docker-fuseki2:latest /vagrant | tee -a build.log"

ui:                                                        ## Open UI
	vagrant ssh vm-fuseki -c "sudo apt-get install -y firefox && firefox http://localhost:3030"

load_docker:                                               ## Load the latest docker image
	vagrant ssh vm-fuseki -c "sudo docker run -d --net="host" -p 3030:3030 brinxmat/docker-fuseki2:latest"

run_fuseki: load_docker ui                                 ## Load docker image and open ui