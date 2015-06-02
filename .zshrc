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
alias ed='gvim --remote-silent'
alias s='ssh'
alias zomg='sudo sshuttle -r hakonl@ft01.sl1.zedge.net:4000 192.155.203.0/24 -vv --dns'
