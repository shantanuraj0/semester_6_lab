
%{
  
%}


%%


  /*lower case strings*/
[a-z]+  {
            printf("Token: STRING;  Lexeme: %s\n", yytext);
        }



Reverse  {
            printf("Token: REVERSE;  Lexeme: %s\n", yytext);
         }




[#()] {
	printf("Token and Lexeme: %s\n",yytext);
      }



	/*new line*/
\n {
	printf("Token and lexeme <newline>\n");
   }



	/*avoid white spaces*/
[ \t]   {    }

  

	/*print error*/
. {
	printf("Error !Invalid character : /string %s\n",yytext);
  }

	
%%

int main(int argc, char *argv[]) {
    yylex();
    return 0;
}
