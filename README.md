# VimFStar Interactive

*VimFStar Interactive* is a [Vim] plugin for [F*], an [ML]-like language with a type system for program verification.

## Features

- `.fst` file detection.
- Syntax highlighting (based on [Vim's OCaml syntax file]).
- Interactive verification of code

## Installation

You can use your favorite [pathogen]-compatible plugin manager to install *VimFStar*. 

If you're using [vim-plug], for example, perform the following steps to install *VimFStar*:

1. Edit your .vimrc and add a `Plug` declaration for VimFStar.

	```vim
	call plug#begin()
	" ...
	Plug 'FStarLang/VimFStar' {'for': 'fstar'}
	" ...
	call plug#end()
	```

2. Restart Vim
3. `:PlugInstall` to install the plugin.

## Use of the interactive verification

This fork was basically to give access to interactive verification.

To test your code and it to the environment up to the current position of the cursor, press ```vim <F2>``` in normal mode

If you want to test some part of your code without adding it to the environment, select it in visual mode and press ```vim <C-i>```

If you want to get the result of what you launched, press ```vim <F3>``` in normal mode

## License

*VimFStar* is distributed under the same license as Vim itself. See [LICENSE] for more details.

## Planned Improvements

- more accurate syntax highlighting.
- [syntastic] integration.

[ML]:http://en.wikipedia.org/wiki/ML_(programming_language)
[Vim]: http://www.vim.org
[F*]: http://www.fstar-lang.org
[vim-plug]: https://github.com/junegunn/vim-plug
[pathogen]: https://github.com/tpope/vim-pathogen
[syntastic]: https://github.com/scrooloose/syntastic
[Vim's OCaml syntax file]: https://github.com/vim/vim/blob/master/runtime/syntax/ocaml.vim
[LICENSE]: http://github.com/FStarLang/VimFStar/blob/master/LICENSE
