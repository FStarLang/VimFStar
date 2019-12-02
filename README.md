# VimFStar

*VimFStar* provides filetype detection and syntax highlighting for [F*].

## Features

- `.fst[i]` file detection.
- Syntax highlighting (based on [Vim's OCaml syntax file]).

## Installation

You can use your favorite [pathogen]-compatible plugin manager to install *VimFStar*. 

If you're using [vim-plug], for example, perform the following steps to install *VimFStar*:

1. Edit your .vimrc and add a `Plug` declaration for VimFStar.

	```vim
	call plug#begin()
	" ...
	Plug 'FStarLang/VimFStar', {'for': 'fstar'}
	" ...
	call plug#end()
	```

2. Restart Vim
3. `:PlugInstall` to install the plugin.

However, this may become redundant for users of `vim-polyglot` as the
contributors are seeking to include this in their bundle of supported file
types.

## License

*VimFStar* is distributed under the same license as Vim itself. See [LICENSE] for more details.

[ML]:http://en.wikipedia.org/wiki/ML_(programming_language)
[Vim]: http://www.vim.org
[F*]: http://www.fstar-lang.org
[vim-plug]: https://github.com/junegunn/vim-plug
[pathogen]: https://github.com/tpope/vim-pathogen
[syntastic]: https://github.com/scrooloose/syntastic
[Vim's OCaml syntax file]: https://github.com/vim/vim/blob/master/runtime/syntax/ocaml.vim
[LICENSE]: http://github.com/FStarLang/VimFStar/blob/master/LICENSE
