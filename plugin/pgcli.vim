" :Less
" turn vim into a pager for psql aligned results
fun! Less()
  autocmd BufEnter * let &titlestring = 'PGCLI Pager'
  set title
  set nocompatible
  set nowrap
  set nowrapscan
  set scrollopt=hor
  set scrollbind
  set nonumber
  set incsearch
  set hlsearch
  set ignorecase
  set smartcase
  set nostartofline
  set scrolloff=5
  if search('RECORD', 'nw') != 1 && search('\v(-+\+)*-+[\+\|]$', 'nw') == 1 "Determining if the output even needs formatting
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
  " hide statusline in lower window
  set laststatus=0
  " hide contents of upper statusline. editor note: do not remove trailing spaces in next line!
  set statusline=\  " Whitespace at the end of this line matters
  " arrows do scrolling instead of moving
  nnoremap OC zL
  nnoremap OB 
  nnoremap OD zH
  nnoremap OA 
  nnoremap l zL
  "nnoremap j 
  nnoremap h zH
  "nnoremap k 
  nnoremap K 20
  nnoremap J 20
  nnoremap L zL
  nnoremap H zH
  "nnoremap u 20
  "nnoremap d 20
  "nnoremap U 20
  "nnoremap D 20
  "nnoremap G Gkk
  noremap <tab> W
  noremap <S-tab> B
  noremap <C-j> <C-w>j
  noremap <C-k> <C-w>k
  nnoremap <Space> <PageDown>
  nnoremap <silent> <leader>h :noh<CR>
  " faster quit (I tend to forget about the upper panel)
  nmap q :qa!
  nmap Q :qa!
  "set noma "Set not modifiable
  set fillchars=stl:-,stlnc:-
endfun
command! -nargs=0 Less call Less()
