# VIM PSQL Pager

A pager for psql built on vim.

## Installation
Assuming you've installed your vim directory at ~/.vim and use pathogen, installing the pager should be as simple as adding the following to your bashrc

```bash
if [ -e ~/.vim/bundle/vim-psql-pager/vimpsqlpager ]; then
  alias psql='PAGER=~/.vim/bundle/vim-psql-pager/vimpsqlpager psql';
fi
```
and for pgcli,

```bash
if [ -e ~/.vim/bundle/vim-psql-pager/vimpgclipager ]; then
  alias pgcli='PAGER=~/.vim/bundle/vim-psql-pager/vimpgclipager pgcli';
fi
```
