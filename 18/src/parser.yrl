Nonterminals expr.
Terminals number '+' '*' '(' ')'.
Rootsymbol expr.

Left 100 '+'.
Left 100 '*'.
% stolen from erlang docs at https://erlang.org/doc/man/yecc.html
expr -> expr '+' expr : {add, '$1', '$3'}.
expr -> expr '*' expr : {mult, '$1', '$3'}.
expr -> '(' expr ')' : '$2'.
expr -> number : '$1'. 