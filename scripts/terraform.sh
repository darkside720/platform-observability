#!/bin/bash

TERRAFORM_VERSION=1.3.7
TERRAGRUNT_VERSION=v0.42.7
TERRAGRUNT_DOWNLOAD_URL=https://jfrog-artifactory..int:443/artifactory/binaries-devops-dev-local/terragrunt/$TERRAGRUNT_VERSION/terragrunt_linux_amd64

TFENV_REPO_URL=ssh://git@gitlab..int/ceng/TER/tfenv.git
TERRAFORM_RELEASES_URL=https://jfrog-artifactory..int/artifactory/releases-hashicorp-remote
TFENV_REMOTE=https://jfrog-artifactory..int/artifactory/releases-hashicorp-remote

function tfenv(){
  if [ ! $(find ~/.tfenv -name tfenv) ]; then
    git clone $TFENV_REPO_URL ~/.tfenv
  fi
  if ! grep -q 'PATH=.*tfenv/bin:' ~/.bash_profile ; then
    echo 'export PATH=$HOME/.tfenv/bin:$PATH' >> ~/.bash_profile
  fi
  if ! grep -q TERRAFORM_RELEASES_URL ~/.bash_profile ; then
    echo "export TERRAFORM_RELEASES_URL=$TERRAFORM_RELEASES_URL" >> ~/.bash_profile
  fi

  
  ~/.tfenv/bin/tfenv install $TERRAFORM_VERSION
  ~/.tfenv/bin/tfenv use $TERRAFORM_VERSION
}

function terragrunt(){
    filename="terragrunt_$TERRAGRUNT_VERSION"
    filepath="/usr/local/bin"

    if [ ! $(find $filepath -name $filename) ]; then
        # echo $TERRAGRUNT_DOWNLOAD_URL
        curl $TERRAGRUNT_DOWNLOAD_URL -O -J -L
        chmod u+x terragrunt_linux_amd64
        mv terragrunt_linux_amd64 "$filepath/$filename"
    fi
    # echo $filename
    cp "$filepath/$filename" "$filepath/terragrunt"
    # ls -sh $filepath
}

function plugins(){
    mkdir -p $1
    while read plugin; do
        filename=$(basename $plugin)
        
        base_directory=$1
        provider=$filename
        arr_provider=(${provider//_/ })
        arr_provider_name=(${arr_provider[0]//-/ })

        provider_version=${arr_provider[1]}
        provider_name=${arr_provider_name[2]}
        provider_full_name="${arr_provider[0]}_v${arr_provider[1]}"

        full_directory="${base_directory}/${provider_name}/${provider_version}/linux_amd64"

        mkdir -p $full_directory
        if [ ! $(find $full_directory -name "${provider_full_name}*") ]; then
            # echo "$plugin"
            # echo "$filename"
            curl $plugin -O -J -L
            unzip -o $filename -d $full_directory
            rm -f $filename
        fi
        
        
    done < $2
}

function clean(){
  ( cd $1 && rm -f *.tfstate* ; rm -fr .terraform )
}

eval $@
