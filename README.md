# VIM PSQL Pager

A pager for psql built on vim.

## Installation
Unfortunately, because I'm using hardcoded paths, the pager is expected to be installed in a directory at ~/.vim/bundle/vim-psql-pager. You can clone this repo to that folder by issuing:
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

## A note about NeoVim
Currently, NeoVim handles input from stdin slightly different than Vim does. I haven't looked into it very much but the tl;dr of the situation is that NeoVim is unsupported. Since I personally use NeoVim, the way I get around this is by setting the linux alternative for vi to use regular vim (the call to vim inside the pager actually uses "vi" which is why this works).

## Acknowledgements
This pager is based on filiprem's answer to the [this](http://unix.stackexchange.com/a/27840) StackExchange question.

## TODO
 - Streamline installation process
 - Remove hardcoded paths
 - Add screenshots to README
 - Add advanced usage section to README
 - Write command should re-add header columns to output
 - Add functions to convert output to CSV
