# VIM PSQL Pager

A pager for psql built on vim.

## Installation
After cloning this repo, simply run the following:
```bash
sudo ./install.py
```

Next, add the following lines to your .bashrc
```bash
alias psql='PAGER=vimpsqlpager psql';
```
and for pgcli,

```bash
alias pgcli='PAGER=vimpgclipager pgcli';
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

#### EXPERIMENTAL: Syntax Highlighting
```
:syntax on
```
I have added some syntax highlighting that can be applied to query results. **WARNING:** Applying highlighting can be extremely slow if there is a lot of data on the screen. It can be especially slow if the result contains a lot of columns. Also, it is worth noting that vim disables highlighting after a certain number of columns. This is set in the 'synmaxcol' variable (it defaults to 3000). View the vim help for more information.

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
 - Add screenshots to README
 - Add advanced usage section to README
 - Add functions to convert output to CSV
