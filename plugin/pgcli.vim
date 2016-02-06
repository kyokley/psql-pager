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
  "execute 'above split'
  silent! %s/^[^a-zA-Z]//
  silent! g/\v^(-+\+)*-+[\+\|]$/d
  let line_length = max(map(getline(1, '$'), 'len(v:val)'))
  new
  wincmd j
  execute "silent! %s/$/\\=repeat(' '," . line_length . "- virtcol('$'))"
  "execute 'silent! 1,1g/List of/d'
  "execute 'silent! 1,1g/Table/+1d'
  execute 'silent! 1,1d'
  "execute 'silent! 1,1d'
  wincmd k
  execute 'silent! norm! P'
  " switch to lower window and scroll 2 lines down
  wincmd j
  silent! $,$d
  norm! gg^
  wincmd k
  execute 'silent! norm! P'
  execute "silent! %s/$/\\=repeat(' '," . line_length . "- virtcol('$'))"
  silent! g/^\s\+$/d

  " resize upper window to one line; two lines are not needed because vim adds separating line
  execute 'resize ' . line('$')
  wincmd j
  set cul
  "execute 'silent! 1,1d'
  "execute 'norm! 2'
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
