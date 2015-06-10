
let s:path = system("echo $PATH")
let s:jpath = substitute(s:path,":",",","g")
let s:jpath = substitute(s:jpath,"\n","","g")
let s:matchs = globpath(s:jpath,"fstar.exe")

"Disable interactive feature
"let g:fstar_inter = 1

"Disable mappings
"let g:fstar_inter_maps = 1


if !empty(s:matchs) && !exists('g:fstar_inter')

  let g:fstar_inter = 1
  pyfile <sfile>:p:h/fstar-inter.py

  fu! Ftest_code ()
    py fstar_vim_test_code()
  endfunction

  fu! Funtil_cursor()
    py fstar_vim_until_cursor()
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

  command Funtil call Funtil()
  command Fresult call Fget_result()
  command Freset call Freset()
  command Fanswer call Fget_answer()

  "Here you can set the color you want for checked code
  highlight FChecked ctermbg=darkgrey

  if !exists("g:fstar_inter_maps")
    vnoremap <buffer> <F2> :<C-u>call Ftest_code()<CR>
    nnoremap <buffer> <F2> :call Funtil_cursor()<CR>
    nnoremap <buffer> <F3> :call Fget_result()<CR>
    nnoremap <buffer> <F4> :call Fget_answer()<CR>
    nnoremap <buffer> <F5> (v)k$<CR>
    "<C-u> is to remove '<,'> which execute the command for each selected line
  endif

endif
