" Vim filetype detection file
" Language:     F*
" Filenames:    *.fst
" Maintainers:  Michael Lowell Roberts <mirobert at microsoft dot com>
" URL:          http://research.microsoft.com/en-us/projects/fstar/
"
" Distributed under the VIM LICENSE. Please refer to the LICENSE file or
" visit <http://vimdoc.sourceforge.net/htmldoc/uganda.html> for details.

autocmd BufNewFile,BufRead *.fst set filetype=fstar
autocmd BufNewFile,BufRead *.fsti set filetype=fstar
