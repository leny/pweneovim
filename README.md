# leny/pweneovim

> My **neovim** configuration files

* * *

**pweneovim** is an utility repository for my neovim configuration files, separated from my [dotfiles](https://github.com/leny/pwendok) by purpose.

* * *

**neovim version:** `0.10.2`

* * *

## Install

Launch the following commands:

    brew install neovim
	cd && git clone https://github.com/leny/pweneovim ~/.pweneovim
	ln -sfv ~/.pweneovim ~/.config/nvim	
	brew install ripgrep
	brew install fd
	npm install -g typescript typescript-language-server vscode-langservers-extracted graphql-language-service-cli
	nvim +PlugInstall +qall
