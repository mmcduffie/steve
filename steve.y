%{
#include <stdio.h>
#include <string.h>
 
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 
  
main()
{
        yyparse();
} 

%}

%token OPEN_OBJECT CLOSE_OBJECT EXEC_OBJECT ASSIGN STRING IDENTIFIER

%%
commands:
        | commands command
        ;

command:
        handle_o
        |
        others
        ;

handle_o:
        OPEN_OBJECT CLOSE_OBJECT
        {
                printf("\tObject opened or closed\n");
        }
        ;

others:
        EXEC_OBJECT ASSIGN STRING IDENTIFIER
        {
                printf("\tEXEC_OBJECT, ASSIGN, STRING, or IDENTIFIER called\n");
        }
        ;
