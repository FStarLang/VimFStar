if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin=1

fu! Ffind_fstar ()
   if exists("g:vimfstar_fstar_exe_path")
       let s = expand(g:vimfstar_fstar_exe_path)
       if executable(s)
           return s
       else
           echoerr "The path specified by g:vimfstar_fstar_exe_path does not point to an executable file. Please verify that this is configured correctly."
       endif
   else
      " convert the system path to a comma-separated list of directories
      " suitable for globpath() consumption.
      " 
      " first, commas must be escaped with a backslash.
      " todo: test a path with a comma in it to make sure this works.
      let l:jpath = substitute($PATH,",","\\,","g")
      " different platforms use different path separators.
      if has('win32')
         " additionally, Windows paths need to have trailing backslashes removed.
         let l:jpath = substitute(l:jpath,"\\;",";","g")
         let l:jpath = substitute(l:jpath,";",",","g")
      else
         let l:jpath = substitute(l:jpath,":",",","g")
      endif
      " todo: ask regarding why newlines would be in $PATH?
      let l:jpath = substitute(l:jpath,"\n","","g")
   "   Decho("[Ffind_fstar] l:jpath=" . l:jpath)

      let l:matchs = globpath(l:jpath,"fstar.exe")
   "   Decho("[Ffind_fstar] l:matchs=" . l:matchs)
      return l:matchs
   endif
endfunction

let s:matchs = Ffind_fstar ()

"Disable mappings
"let g:fstar_inter_maps = 1

if g:vimfstar_interactive && !empty(s:matchs) && !exists('s:fstar_inter')

  let s:fstar_inter = 1
  pyfile <sfile>:p:h/fstar-inter.py

  fu! Ftest_code ()
    py fstar_vim_test_code()
  endfunction

  fu! Funtil_cursor()
    py fstar_vim_until_cursor()
  endfunction

  fu! Funtil_cursor_quick()
    py fstar_vim_until_cursor(True)
  endfunction

  fu! Fget_result()
    py fstar_vim_query_answer()
  endfunction

  fu! Freset()
    py fstar_reset()
  endfunction

  fu! Fget_answer()
    py fstar_vim_get_answer()
  endfunction

  py fstar_init()

  command Funtil call Funtil_cursor()
  command Funtilquick call Funtil_cursor_quick()
  command Fresult call Fget_result()
  command Freset call Freset()
  command Fanswer call Fget_answer()

  "Here you can set the color you want for checked code
  highlight FChecked ctermbg=darkgrey guibg=lightGreen
endif


if !exists("g:fstar_inter_maps")
  vnoremap <buffer> <F2> :<C-u>call Ftest_code()<CR>
  nnoremap <buffer> <F2> :call Funtil_cursor()<CR>
  nnoremap <buffer> <F3> :call Fget_result()<CR>
  nnoremap <buffer> <F4> :call Fget_answer()<CR>
  nnoremap <buffer> <F5> (v)k$<CR>
  nnoremap <buffer> <F6> :call Funtil_cursor_quick()<CR>
  "<C-u> is to remove '<,'> which execute the command for each selected line
endif


" Add mappings, unless the user didn't want this.
if !exists("no_plugin_maps") && !exists("no_fstar_maps")
  " (un)commenting
  if !hasmapto('<Plug>Comment')
    nmap <buffer> <LocalLeader>c <Plug>LUncomOn
    xmap <buffer> <LocalLeader>c <Plug>BUncomOn
    nmap <buffer> <LocalLeader>C <Plug>LUncomOff
    xmap <buffer> <LocalLeader>C <Plug>BUncomOff
  endif

  nnoremap <buffer> <Plug>LUncomOn gI(* <End> *)<ESC>
  nnoremap <buffer> <Plug>LUncomOff :s/^(\* \(.*\) \*)/\1/<CR>:noh<CR>
  xnoremap <buffer> <Plug>BUncomOn <ESC>:'<,'><CR>`<O<ESC>0i(*<ESC>`>o<ESC>0i*)<ESC>`<
  xnoremap <buffer> <Plug>BUncomOff <ESC>:'<,'><CR>`<dd`>dd`<
endif

