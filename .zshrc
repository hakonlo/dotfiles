source ~/dotfiles/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle sudo
antigen bundle wd

antigen theme ys


RELEASE_ID=`lsb_release --id`
if [[ $RELEASE_ID =~ "Arch" ]]
then
    antigen bundle archlinux
fi

antigen apply



alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'

export GOPATH=~/kode/Go
PATH=$PATH:${GOPATH//://bin:}/bin
