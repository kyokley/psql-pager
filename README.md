# VIM PSQL Pager

A pager for psql built on vim.

![Screenshot](/../screenshots/screenshots/output.gif?raw=true)

**NOTE:** Knowledge of vim is not required to use this pager! If you can get around *less* you should feel comfortable here.

## Features
- Sticky headers
- Searching within results
- Sorting
- psql and pgcli support
- Experimental highlighting (Read below about limitations)

Since the pager is built using vim, most standard vim commands should be available. Any commands that have been remapped can be found below. Although knowledge of vim is not necessary to use the pager, it can help in understanding some of the more advanced features.

## Installation
Use Docker!
For psql:
```
docker run --rm -it --network=host kyokley/psql -U postgres -h localhost -p 5432
```
For pgcli:
```
docker run --rm -it --network=host kyokley/pgcli postgresql://postgres@localhost:5432
```

Since those commands are a little wordy, it can be useful to alias them in your bashrc
```
psql() {
    docker run \
        --rm -it \
        --network=host \
        kyokley/psql:latest \
        "$@"
       }

pgcli() {
    docker run \
        --rm -it \
        --network=host \
        kyokley/pgcli:latest \
        "$@"
       }
```
Now the commands can be called just as you'd expect.
For psql:
```
psql -U postgres -h localhost -p 5432
```
For pgcli:
```
pgcli postgresql://postgres@localhost:5432
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

#### Searching
```
/{pattern}<CR> -> Search for {pattern}
n -> Move to next match
N -> Move to previous match
```

#### Sorting
```
:SortCol
```
I have added a convenience function capable of sorting the output based on a given column. The sort uses the column that the cursor is currently in.

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

## Acknowledgements
This pager is based on filiprem's answer to [this](http://unix.stackexchange.com/a/27840) StackExchange question.

## TODO
 - Add advanced usage section to README
 - Add functions to convert output to CSV
