%{
#include<stdio.h>

#define NUM 258
#define ID 259
#define ENDLINE 260
%}


%option yylineno

%%

[ \t]+ ;

\n                      { return ENDLINE; }

[a-zA-Z][a-zA-Z0-9]*   	{ return ID; }

[-]?[0-9]+              { return NUM; }

[-]?[0-9]+/[a-z]        {
                                fprintf(stderr, "Warning: Incorrect integer '%s' in line %d\n", yytext, yylineno);
                                return NUM;
                        }

[\+\-\*\/\(\)]          { return *yytext; }

.                       { fprintf(stderr,"ERROR, not a valid character : %s in line %d\n",yytext,yylineno); }

%%

int yywrap(void) {
        return 1;
}

void main(int argc, char* argv[]){
        if (argc == 2){
                yyout = fopen(argv[1],"w");
        }
        while(1){
                int token = yylex();
                if(token == 0) {
                        break;
                }
                else if(token == ENDLINE){
                        fprintf(yyout,"$\n");
                }
                else if(token == NUM) {
                        fprintf(yyout,"num ");
                }
                else if(token == ID) {
                        fprintf(yyout,"id ");
                }
                else {  
                        fprintf(yyout,"%s ",yytext);
                }
        }
}
