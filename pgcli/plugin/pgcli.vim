source $HOME/config/common.vim

autocmd BufEnter * let &titlestring = 'PGCLI Pager'

fun! Less()
  if search('RECORD', 'nw') != 1 && search('\v(-+\+)*-+[\+\|]$', 'nw') == 1 && search('^|\sCommand\s\+|\sDescription\s\+|$', 'nw') != 2 "Determining if the output even needs formatting
      " Trim fancy table formatting
      silent! %s/^[^a-zA-Z]//
      silent! g/\v^(-+\+)*-+[\+\|]$/d

      " Get the length of the longest line
      let line_length = max(map(getline(1, '$'), 'len(v:val)'))

      " Pad lines so that everything is the same length
      execute "silent! %s/$/\\=repeat(' '," . line_length . "- virtcol('$'))"

      " Delete the header row into a register
      1,1d p

      " Create a new split and paste the header
      new
      silent! norm! "pP

      " Get the row count and add it to the header section
      wincmd j
      silent! $,$d p
      norm! gg^
      wincmd k
      silent! norm! "pP

      " Remove empty rows
      silent! g/^\s*$/d

      " Resize the header section based on how many rows we have
      execute 'resize ' . line('$')
      wincmd j
      set cul
  else
      nnoremap j 
      nnoremap k 
      " If we only have one line, just print it back to the console and quit
      if line('$') == 1
          1,1d p
          silent! exe '!echo ' . @p
          qa!
      endif
  endif

  call PostLess()
endfun
command! -nargs=0 Less call Less()
