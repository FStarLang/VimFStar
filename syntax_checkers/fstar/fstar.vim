" Syntastic syntax checker file
" Language:     F*
" Filenames:    *.fst
" Maintainers:  Michael Lowell Roberts <mirobert at microsoft dot com>
" URL:          http://research.microsoft.com/en-us/projects/fstar/
"
" Distributed under the VIM LICENSE. Please refer to the LICENSE file or
" visit <http://vimdoc.sourceforge.net/htmldoc/uganda.html> for details.

if exists('g:loaded_syntastic_fstar_checker')
    finish
endif
let g:loaded_syntastic_fstar_checker = 1

if !exists('g:syntastic_fstar_sort')
    let g:syntastic_fstar_sort = 1
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_fstar_fstar_IsAvailable() dict
"    Decho "self.getExec() => " . self.getExec()
    return executable(self.getExec())
endfunction

"function! SyntaxCheckers_fstar_fstar_GetHighlightRegex(item)
    "if match(a:item['text'], 'assigned but unused variable') > -1
        "let term = split(a:item['text'], ' - ')[1]
        "return '\V\\<'.term.'\\>'
    "endif

    "return ''
"endfunction

function! SyntaxCheckers_fstar_fstar_GetLocList() dict
    let makeprg = self.makeprgBuild({
                \ 'args': '',
                \ 'args_after': '' })
    let errorformat = '\ %#%f(%l\\\,%c):\ %m'
    let env = {}
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat, 'env': env })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
            \ 'filetype': 'fstar',
            \ 'name': 'fstar',
            \ 'exec': 'fstar' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
