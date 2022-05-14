%{
#include <stdio.h>
#include <string.h>
#include "node.h"
#include "y.tab.h"

void yyerror(char *);
%}



id ([A-Za-z_]([A-Za-z_]|0-9)*)
num ((-)?([0-9]+)(.[0-9]+)?)
symbol [-+*/()]



%%


[ \t]+      {}

\n          {
                return  *yytext;
            }

{num}       {
                yylval.str = strdup(yytext);
                return  NUM;
            }

{id}        {
                yylval.str = strdup(yytext);
                return  ID;
            }

{symbol}    {
                return  *yytext;
            }

.           {
               	return *yytext;
            }





%%



void yyerror(char *s) {
    fprintf(stderr, "line %d: yytext = %s.  Error : %s.\n", yylineno, yytext, s);
}



int yywrap(void) {
   return 1;
}
