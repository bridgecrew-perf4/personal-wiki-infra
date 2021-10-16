#!/usr/bin/env make

.PHONY: install
install:
	pipenv install --dev
	pipenv run ansible-galaxy role install --force --role-file packer/ansible/requirements.yml
	pipenv run ansible-galaxy collection install --upgrade --requirements-file packer/ansible/requirements.yml

# Only run this on GitHub Codespaces in order to set up Python 3.9
.PHONY: codespace-install
codespace-install:
	make hashicorp-install
	sudo add-apt-repository -y ppa:deadsnakes/ppa
	sudo apt-get update
	sudo apt-get install -y python3.9
	sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
	sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2
	make install

.PHONY: hashicorp-install
hashicorp-install:
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $$(lsb_release -cs) main"
	sudo apt-get update && sudo apt-get install -y packer terraform

.PHONY: lint
lint:
	cd packer/ansible && pipenv run yamllint .
	cd packer/ansible && pipenv run ansible-lint

.PHONY: validate
validate:
	pipenv run packer validate packer/wiki.pkr.hcl

.PHONY: format
format:
	cd terraform && terraform fmt
	pipenv run packer fmt packer/wiki.pkr.hcl

.PHONY: test
test:
	cd packer/ansible && pipenv run molecule test

.PHONY: build
build:
	ANSIBLE_VAULT_PASSWORD_FILE=packer/ansible/.vaultpass pipenv run packer build packer/wiki.pkr.hcl

.PHONY: init
init:
	cd terraform && terraform init

.PHONY: plan
plan: init
	cd terraform && terraform plan

.PHONY: apply
apply: init
	cd terraform && terraform apply

.PHONY: destroy
destroy: init
	cd terraform && terraform destroy
