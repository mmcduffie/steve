%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
\[                      return OPEN_OBJECT;
\]                      return CLOSE_OBJECT;
>                       return EXEC_OBJECT;
:                       return ASSIGN;
L?\"(\\.|[^\\"])*\"     return STRING;
[a-z|A-Z|0-9]+          return IDENTIFIER;
%%
