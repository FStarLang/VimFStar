" Syntastic syntax checker file
" Language:     F*
" Filenames:    *.fst
" Maintainers:  Michael Lowell Roberts <mirobert at microsoft dot com>
" URL:          http://research.microsoft.com/en-us/projects/fstar/
"
" Distributed under the VIM LICENSE. Please refer to the LICENSE file or
" visit <http://vimdoc.sourceforge.net/htmldoc/uganda.html> for details.

if exists('g:loaded_syntastic_fstar_fstar_checker')
    finish
endif
let g:loaded_syntastic_fstar_checker = 1

if !exists('g:syntastic_fstar_fstar_sort')
    let g:syntastic_fstar_fstar_sort = 1
endif

let s:save_cpo = &cpo
set cpo&vim

let s:fstar_exe_path = "fstar.exe"
if exists("g:vimfstar_fstar_exe_path")
    let s = expand(g:vimfstar_fstar_exe_path)
    if executable(s)
        let s:fstar_exe_path = s
    else
        echoerr "The path specified by g:vimfstar_fstar_exe_path does not point to an executable file. Please verify that this is configured correctly."
    endif
endif

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
                \ 'exe': s:fstar_exe_path })
    " ERROR: Syntax error near line $LINE, character $COLUMN in file $FILE
    let errorformat = 'ERROR:\ %m\ near\ line %l\,\ character\ %c\ in\ file\ %f,'
    " $FILE($LINE,$COLUMN-6,16) : Error
    " Expected expression of type "bool";
    " got expression "1" of type "int"
    let errorformat .= '%E%f(%l\,%c%*[^:]:\ Error,'
    " $FILE($LINE0,$COL0-$LINE1,$COL1): Subtyping check failed...
    let errorformat .= '%f(%l\,%c%*[^:]:%m,'
    " $FILE: Expected a module...
    let errorformat .= '%f:%m,'
    " add unrecognized lines to the preceeding error.
    let errorformat .= '%+C%m'
    let env = {}
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat, 'env': env })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
            \ 'filetype': 'fstar',
            \ 'name': 'fstar',
            \ 'exec': s:fstar_exe_path})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et ft=vim:
