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

%union {
  char * string;
}

%token <string> STRING
%token OPEN_OBJECT CLOSE_OBJECT EXEC_OBJECT MATH ASSIGN IDENTIFIER

%%

objects:  /* empty */
	| objects object
	;

object:	  OPEN_OBJECT CLOSE_OBJECT
	| OPEN_OBJECT slot CLOSE_OBJECT
	;

slot:	  IDENTIFIER ASSIGN object
	| IDENTIFIER ASSIGN IDENTIFIER
	| IDENTIFIER ASSIGN STRING
	| IDENTIFIER ASSIGN MATH
	| IDENTIFIER ASSIGN EXEC_OBJECT object
	;
