#!/bin/bash

#git clone git://github.com/Digo/dotvim.git ~/.vim
#git clone ssh://mli-desktop.cs/home/d57wang/Repositories/vim.git ~/.vim

#Create symlinks:
ln -s ~/.vim/vimrc ~/.vimrc
mkdir -p ~/.vim/.backup

git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall