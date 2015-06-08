
function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ?
  1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

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
vnoremap <buffer> <C-i> :<C-u>call Ftest_code()<CR>
nnoremap <buffer> <F2> :call Funtil_cursor()<CR>
nnoremap <buffer> <F3> :call Fget_result()<CR>
"<C-u> is to remove '<,'> which execute the command for each selected line
