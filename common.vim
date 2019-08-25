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
        echom "Execute :u[ndo]<CR> to switch back to standard formatting"
        exec 'norm ' . s:current_line . 'gg'
    endif
endfunction

function SortByColumn(...)
    let current_pos = getpos('.')
    if exists('a:1')
        let sort_column = a:1
    else
        silent! exec 'norm ?|\|^'
        let sort_column = virtcol('.')
    endif

    wincmd j

    exec 'sor /.*\%' . sort_column . 'v/'
    call setpos('.', current_pos)
endfunction

function PostLess()
    " Move to the beginning of the line
    norm! ^
endfunction

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
set noswapfile
set ft=psql

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
noremap K 20
noremap J 20
nnoremap L zL
nnoremap H zH
nnoremap u 20
nnoremap d 20
nnoremap U 20
nnoremap D 20
nnoremap G Gkk
noremap <tab> W
noremap <S-tab> B
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
nnoremap <Space> <PageDown>
nnoremap <silent> <leader>h :noh<CR>
" faster quit (I tend to forget about the upper panel)
nnoremap q :qa!
nnoremap Q :qa!
"set noma "Set not modifiable
nnoremap i <nop>
nnoremap I <nop>
nnoremap a <nop>
nnoremap A <nop>
nnoremap s <nop>
nnoremap S <nop>
nnoremap o <nop>
nnoremap O <nop>
nnoremap c <nop>
nnoremap C <nop>
nnoremap r <nop>
nnoremap R <nop>
set fillchars=stl:-,stlnc:-

autocmd BufWritePre * call WriteHeader()
autocmd BufWritePost * call RemoveHeader()

command! SortCol call SortByColumn()
