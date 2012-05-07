%{
#include <stdio.h>
%}

%%
\[                      printf("OPEN_OBJECT ");
\]                      printf("CLOSE_OBJECT ");
>                       printf("EXEC_OBJECT ");
:                       printf("ASSIGN ");
L?\"(\\.|[^\\"])*\"     printf("STRING ");
[a-z|A-Z|0-9]+          printf("IDENTIFIER ");
%%
