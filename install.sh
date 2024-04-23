#!/bin/bash
rm -rf ~/.tfenv
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH=$PATH:$HOME/.tfenv/bin' >> ~/.bashrc
mkdir -p $HOME/bin
ln -s ~/.tfenv/bin/* $HOME/bin