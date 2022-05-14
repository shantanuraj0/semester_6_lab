%{

void yyerror(char *);

%}


%%
regular  {
            printf("Token : regular; Lexeme : %s\n",yytext);
         }


s?i?m?p?l?e? {
                 printf("Token: simple; Lexeme: %s\n",yytext);
             }



c?o?m?p?o?u?n?d?  {
                     printf("Token: compound; Lexeme: %s\n",yytext);
                  }


[0-9]+       {
                printf("Token: NUM; Lexeme: %s\n",yytext);
             }


[(),]       {
                printf("Token and Lexeme: %s\n",yytext);  
            }


\n          {
                 printf("Token and Lexeme : <newline>\n");
            }


[A-Za-z$#@_]+ {
			yyerror("Invaid Input!");
	}


.       {
           yyerror("Invaid Input!");
        }



%%

void yyerror(char *s) {
      fprintf(stderr, "line %d: invalid input = %s.  Error message!: %s.\n", yylineno, yytext, s);
}


int main()
{
  yylex();

}