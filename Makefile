.PHONY: help

export PATH := $(PWD)/bin:$(PATH)

help: ## show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

tfenv: ## installs tfenv to $HOME/.tfenv
	./scripts/terraform.sh tfenv

plugins: ## downloads provider plugins from the user defined list
	./scripts/terraform.sh plugins ~/.terraform.d/plugins/artifactory.ews.int/releases-hashicorp terraform-plugins

terragrunt: ## installs terragrunt to ./bin/terragrunt
	./scripts/terraform.sh terragrunt

dependencies: tfenv plugins terragrunt ## installs tfenv, terraform plugins and terragrunt

metadata: ## creates vars file
	./live/metadata.yaml.sh

list-live-modules: ## lists terragrunt root modules in the target directory
	@find -mindepth 5 $(DIR) -name '*terragrunt.hcl' |grep -v '.terragrunt-cache'|xargs dirname

terragrunt-init: ## runs terragrunt init on the target directory
	cd $(DIR) && terragrunt init | grep -v "Downloading git:\|- "

terragrunt-plan: terragrunt-init ## runs terragrunt plan on the target directory
	cd $(DIR) && terragrunt plan | grep -v "Refreshing state...\|Reading...\|Read complete after"

terragrunt-destroy-plan: terragrunt-init ## runs terragrunt plan on the target directory
	cd $(DIR) && terragrunt plan -destroy | grep -v "Refreshing state...\|Reading...\|Read complete after"

terragrunt-show: terragrunt-init ## runs terragrunt plan on the target directory
	cd $(DIR) && terragrunt show --json $(PLAN)

terragrunt-apply: ## runs terragrunt apply on the target directory
	cd $(DIR) && terragrunt apply -auto-approve | grep -v "Refreshing state...\|Reading...\|Read complete after \|Downloading git:\|- "

terragrunt-destroy: terragrunt-init ## runs terragrunt plan on the target directory
	cd $(DIR) && terragrunt destroy -auto-approve | grep -v "Refreshing state...\|Reading...\|Read complete after \|Downloading git:\|- "


#
## Gitlab CI
#

terragrunt-plan-out: terragrunt-init ## runs terragrunt plan on the target directory
	cd $(DIR) && terragrunt plan -out=$(PLAN)

terragrunt-apply-plan: ## runs terragrunt apply on the target directory
	cd $(DIR) && terragrunt apply -auto-approve -input=false $(PLAN)

#
## Targeted Resources
#

terragrunt-plan-target: terragrunt-init ## runs terragrunt plan on the target directory
	cd $(DIR) && terragrunt plan -target=$(TAR)

terragrunt-apply-target: ## runs terragrunt apply on the target directory
	cd $(DIR) && terragrunt apply -target=$(TAR) --auto-approve

#
## State Management ##
#

terragrunt-taint: terragrunt-init
	cd $(DIR) && terragrunt taint $(TAR)

terragrunt-detach: terragrunt-init
	cd $(DIR) && terragrunt state rm $(TAR)

terragrunt-import: terragrunt-init
	cd $(DIR) && terragrunt import $(TAR) $(VAL)

terragrunt-output:
	cd $(DIR) && terragrunt output

#
## Run all live code under an environment
#

terragrunt-init-all: ## runs terragrunt init on live modules
	find $(DIR) -not -path '*/.terragrunt-cache/*' -not -path '$(DIR)/terragrunt.hcl'  -type f -name terragrunt.hcl -execdir terragrunt init \;

terragrunt-plan-all: ## runs terragrunt plan-all on the live environment path
	cd $(DIR) && terragrunt plan-all

terragrunt-apply-all: ## runs terragrunt apply-all on the live environment path
	cd $(DIR) && TF_INPUT=0 terragrunt apply-all

terragrunt-destroy-all: ## runs terragrunt destroy-all on the live environment path
	cd $(DIR) && terragrunt destroy-all
