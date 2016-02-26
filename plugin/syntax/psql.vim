"Syntax highlighting courtesy of Jason Munro
"http://unencumberedbyfacts.com/2016/01/04/psql-vim-happy-face/
syn region Heading start=/^ \l/ end=/[-+]\+$/
syn match Border "|"
syn match IntVal "\(^\||\)\@<=\s\+\d\+\(\s*\n\|\s\+|\)\@="
syn match NullVal " NULL\(\n\| \)"
syn match NullVal2 " <null>\(\n\| \)"
syn match NegVal " -\d\+\(\n\| \)"
syn match FloatVal " \d\+\.\d\+\(\n\| \)"
syn match NegFloatVal " -\d\+\.\d\+\(\\n\| \)"
syn match DateTime "\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}\([\.0-9-+:]\+\s\+\|\s\+\| \)"
syn match TrueVal " t\(\n\| \)"
syn match TrueVal2 " True\(\n\| \)"
syn match FalseVal " f\(\n\| \)"
syn match FalseVal2 " False\(\n\| \)"

hi def Heading ctermfg=246
hi def IntVal ctermfg=229
hi def FalseVal ctermfg=88
hi def FalseVal2 ctermfg=88
hi def NullVal ctermfg=242
hi def NullVal2 ctermfg=242
hi def Border ctermfg=240
hi def NegFloatVal ctermfg=160
hi def FloatVal ctermfg=230
hi def NegVal ctermfg=160
hi def DateTime ctermfg=111
hi def TrueVal ctermfg=64
hi def TrueVal2 ctermfg=64
