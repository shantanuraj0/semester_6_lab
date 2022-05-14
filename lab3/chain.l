	//declarations
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
void yyerror(char *);
%}


%%

	//rules

    
[a-z]+  {
            yylval.str = strdup(yytext);
            return  STRING;
        }



Reverse  {
            yylval.str = strdup(yytext);
            return  REVERSE;
         }




[#()]   {
            return  *yytext;
        }




\n      {
            return  *yytext;
        }




[ \t]   {    }    


[a-zA-Z0-9@$!%*&/]+	{
			 return *yytext;
			} 


.       {
           yyerror("invalid character");
        }


%%


	//auxiliary functions  

void yyerror(char *s) {
      fprintf(stderr, "line %d: invalid input = %s.  Error!: %s.\n", yylineno, yytext, s);
}


int yywrap(void) {
   return 1;
}

