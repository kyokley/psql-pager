# VIM PSQL Pager

A pager for psql built on vim.

## Installation
Unfortunately, because I'm using hardcoded paths, the pager is expected to be installed in a dir at ~/.vim/bundle/vim-psql-pager. You can clone this repo to that folder by issuing:
```
git clone https://github.com/kyokley/vim-psql-pager.git ~/.vim/bundle/vim-psql-pager
```

Next, add the following lines to your .bashrc
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
## How it works
The process is fairly simple. I have created a series of vim commands that format the data in a way that gives the illusion of sticky header columns. This is achieved by creating a split with headers in the top area and the rest of the data in the bottom area.

## Commands
When the pager first starts, it overrides the user's vimrc and replaces it with pager specific commands. I tried to build off the default vim commands so if you're familiar with those, things should just come naturally to you.

#### Moving around
```
h -> Scroll left
j -> Move the cursor down one line
k -> Move the cursor up one line
l -> Scroll right

Shift-J -> Jump down
Shift-K -> Jump up

Tab -> Move to the next word
Shift-Tab -> Move to the previous word

Space -> PageDown
```

#### Moving between splits
```
Ctrl-J -> Move to the data split
Ctrl-K -> Move to the header split
```

#### Exiting
```
q -> Quit
Q -> Quit
```

Everything else remains the same. That means you're still able to leverage standard vim commands. For example, in result sets that have many columns, I find it useful to be able to jump to a specific column. This can be done by moving into the header split and searching for the column name. Since the splits are scrollbinded, the data will shift as well.
