# leny/pweneovim

> My **neovim** configuration files

* * *

**pweneovim** is an utility repository for my neovim configuration files, separated from my [dotfiles](https://github.com/leny/pwendok) by purpose.

* * *

## Install

Launch the following commands:

    pip3 install --user --upgrade neovim
	cd && git clone https://github.com/leny/pweneovim ~/.pweneovim
	ln -sfv ~/.pweneovim ~/.config/nvim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall
