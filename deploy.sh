#!/bin/bash
# vim:foldmethod=marker
# Preamble {{{
set -e
SCRIPT_DIR=$(cd `dirname $0` && pwd)
# }}}
# rust/cargo {{{
if ! [ -x "$(command -v cargo)" ]; then 
    curl https://sh.rustup.rs -sSf | sh
fi
export PATH=~/.cargo/bin/:$PATH
# }}}
# tmux plugin manager {{{
if ! [ -d ~/.tmux ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
# }}}
# ripgrep {{{
if ! [ -x "$(command -v rg)" ]; then 
    cargo install ripgrep
fi
# }}}
# fzf {{{
if ! [ -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
else
    echo "Skipping fzf installation"
fi
# }}}
# language servers {{{
[ -d ~/.langservers ] || mkdir ~/.langservers
# }}}
# python language server {{{
if [ -x "$(command -v virtualenv)" ] && ! [ -d ~/.langservers/python ]; then
    bash<<EOF
    mkdir ~/.langservers/python
    cd ~/.langservers/python
    virtualenv venv
    source venv/bin/activate
    pip install python-language-server
    pip install python-language-server[rope]
    pip install python-language-server[mccabe]
EOF
else
    echo "Skipping python language server installation."
fi
# }}}
# install dein {{{
source $SCRIPT_DIR/lib.sh
install_dein ~/.cache/dein > /dev/null
# }}}
# vim {{{
mkdir -pv $HOME/vimswap
# }}}
# dotfiles {{{
for i in .*; do
    if [ $i == "." ] || [ $i == ".." ] || [ $i == ".git" ]; then
        continue
    fi
    home_path=$HOME/`basename $i`
    if [ -f $home_path -o -L $home_path ]; then
        mv $home_path ${home_path}.old;
    fi;
    ln -s $PWD/$i $HOME
done
# }}}
# configure git {{{
git config --global user.name "Samer Atiani"
git config --global user.email "satiani@gmail.com"
git config --global color.ui auto
git config --global alias.st status
git config --global push.default simple
# }}}
echo "Done."
