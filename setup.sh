#!/usr/bin/env bash

DOTFILES=`pwd`
echo $DOTFILES

git submodule init
git submodule update

cd ~
rm -rf ~/.vimrc ~/.vim ~/.zshrc
mkdir -p ~/.vim/bundle

ln -s "$DOTFILES"/.vim/bundle/Vundle.vim ~/.vim/bundle/Vundle.vim
ln -s "$DOTFILES"/.vimrc ~/.vimrc
vim +PluginInstall +qall

ln -s "$DOTFILES"/.zshrc ~/.zshrc

