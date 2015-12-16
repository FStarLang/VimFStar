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
	Plug 'FStarLang/VimFStar', {'for': 'fstar'}
	" ...
	call plug#end()
	```

2. Restart Vim
3. `:PlugInstall` to install the plugin.

## Use of the interactive verification

First, put ```fstar.exe``` in your $PATH. VimFStar will check that ```fstar.exe``` is present before loading interactive functions.

To test your code and it to the environment up to the current position of the cursor, press ```<F2>``` in normal mode. The marker ```v``` is set to the line just after the end of the checked part, so you can go there with ```'v```. If you already know that your code is correct until the cursor and just want to add it to the context, you can press ```<F6>``` for a quick test (useful for projects with thousands of lines and where normal tests last very long).

If you want to test some part of your code without adding it to the environment, select it in visual line mode (Shift+V) and press ```<F2>```

If you want to get the result of the test you launched, press ```<F3>``` in normal mode

If you want to see again the errors sent by F*, press ```<F4>```

If you are working on a big chunk of code, and it has no empty new line inside, you can try to select it quicker with ```<F5>``` in order to check it with ```<F2>```. You can go back to where you were with ```<CTRL-o><CTRL-o>``` 

You can reset the interaction with the command ```:Freset``` in case something went wrong or if
you want to change a checked part.

If you want to use library files and/or set options, use ```build-config``` in your file. For example, if my file is at ```$FSTAR_HOME/examples/metatheory``` and I want to use ```classical.fst``` and ```ext.fst``` in ```$FSTAR_HOME/lib``` and set some options, I will put the following code at the top of my file:

```fstar
(*--build-config
    options:--z3timeout 20 --max_fuel 8 --max_ifuel 6 --initial_fuel 4 --initial_ifuel 2;
    other-files:../../lib/classical.fst ../../lib/ext.fst
  --*)
```

This configuration is read when the buffer is loaded or when the plugin is reset. So do not forget to reset the plugin if you change `build-config`.

## License

*VimFStar* is distributed under the same license as Vim itself. See [LICENSE] for more details.

## Planned Improvements

- more accurate syntax highlighting.
- [syntastic] integration.
- better highlighting of verified code
- quick access to error locations
- ability to pop environment

[ML]:http://en.wikipedia.org/wiki/ML_(programming_language)
[Vim]: http://www.vim.org
[F*]: http://www.fstar-lang.org
[vim-plug]: https://github.com/junegunn/vim-plug
[pathogen]: https://github.com/tpope/vim-pathogen
[syntastic]: https://github.com/scrooloose/syntastic
[Vim's OCaml syntax file]: https://github.com/vim/vim/blob/master/runtime/syntax/ocaml.vim
[LICENSE]: http://github.com/FStarLang/VimFStar/blob/master/LICENSE
