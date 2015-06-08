
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

highlight FChecked ctermbg=darkgreen

py fstar_init()
vnoremap <buffer> <F2> :<C-u>call Ftest_code()<CR>
nnoremap <buffer> <F2> :call Funtil_cursor()<CR>
nnoremap <buffer> <F3> :call Fget_result()<CR>
"<C-u> is to remove '<,'> which execute the command for each selected line
