" source $HOME/config/common.vim

fun! Less()
  if search('RECORD', 'nw') != 1 && search('^General', 'nw') != 1
      let line_length = max(map(getline(1, '$'), 'len(v:val)'))
      execute "silent! %s/$/\\=repeat(' '," . line_length . "- virtcol('$'))"

      if search('List of', 'nw') == 1 || search('Table', 'nw') == 1
          silent! 1,3d p
      else
          silent! 1,2d p
      endif

      new
      silent! norm! "pP

      wincmd j
      silent! g/^(\d\+ row/d | wincmd k | execute "silent! norm! P" | wincmd j
      silent! g/\v^\s*$/d
      norm! gg^
      wincmd k
      execute "silent! %s/$/\\=repeat(' '," . line_length . "- virtcol('$'))"
      silent! g/\v^\s*$/d
      silent! g/\v^(-+\+)*-+\s*$/d
      norm! gg^
      " resize upper window
      execute 'resize ' . line('$')
      wincmd j
      set cul
  else
      nnoremap j 
      nnoremap k 
  endif

  call PostLess()
endfun
command! -nargs=0 Less call Less()
