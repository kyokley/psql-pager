" Turn vim into a pager for psql aligned results
function WriteHeader()
    wincmd j
    if search('RECORD', 'nw') != 1
        let s:current_line = line('.')
        wincmd k
        if exists("s:display_mode") && s:display_mode == 'CSV'
            norm G
            silent! s/\v\s+\|\s+([^\|]{-})\ze\s+(\||$)\@=/,\1/g
            undojoin | silent! s/\v(^\s+|\s+$)//g
        endif
        silent! 2,2y p
        norm u
        wincmd j
        0put p
    endif
endfunction

function! RemoveHeader()
    wincmd j
    if search('RECORD', 'nw') != 1
        0d
        exec 'norm ' . s:current_line . 'gg'
    endif
endfunction

function ConvertToCSV()
    wincmd j
    if search('RECORD', 'nw') != 1
        let s:current_line = line('.')
        let s:display_mode = 'CSV'
        silent! %s/\v\s+\|\s+([^\|]{-})\ze\s+(\||$)\@=/,\1/g
        undojoin | silent! %s/\v(^\s+|\s+$)//g
        echom "Press u[ndo] to switch back to standard formatting"
        exec 'norm ' . s:current_line . 'gg'
    endif
endfunction

fun! Less()
  autocmd BufEnter * let &titlestring = 'PSQL Pager'
  set title
  set nocompatible
  set nowrap
  set nowrapscan
  set scrollopt=hor
  set scrollbind
  set nonumber
  set incsearch
  set hlsearch
  set smartcase
  set nostartofline
  set scrolloff=5
  if search('RECORD', 'nw') != 1
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
  nnoremap h zH
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

  autocmd BufWritePre * call WriteHeader()
  autocmd BufWritePost * call RemoveHeader()
endfun
command! -nargs=0 Less call Less()
