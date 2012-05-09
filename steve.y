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
root:	  /* empty */
        | root object
        ;

object:	  OPEN_OBJECT CLOSE_OBJECT
	| OPEN_OBJECT slot CLOSE_OBJECT
	;

slot:	  IDENTIFIER ASSIGN object
	| slot object
	;
