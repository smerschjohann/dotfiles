#!/bin/bash
INSTALL_DEPENDENCIES=${1:-true}

if [[ $INSTALL_DEPENDENCIES == true ]]; then
    sudo apt update
    sudo apt install -y fzf zsh moreutils

    if [[ $(go version) != *"1.18.3"*  ]]; then 
        echo "downloading golang"    
        sudo rm -rf /usr/local/go
        curl -Ls https://go.dev/dl/go1.18.3.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -
    fi
fi

mkdir -p $HOME/bin
export PATH=$HOME/bin:$HOME/.dotfiles/bin:$PATH
chmod a+x $PWD/bin

curl -sLo $HOME/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
gh-r helmfile/helmfile linux_amd64 "-z helmfile"
gh-r google/go-containerregistry Linux_x86_64 "-z crane gcrane"

chmod a+x -R $HOME/bin

ln -s $PWD/zshrc $HOME/.zshrc
ln -s $PWD/p10k.zsh $HOME/.p10k.zsh
