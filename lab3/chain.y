	//declarations

%{
#include <stdio.h>
#include <string.h>
int yylex(void);
void yyerror(char *);   
char *reverse(char *);
%}


%union {
    char *str;
};

	//token declarations
%token  <str>  STRING
%token  <str>  REVERSE

	//declarations of non-terminal symbols
%type  <str>  start
%type  <str>  expr
%left '#'

	//which non-terminal is start symbol
%start  start


%%
       
	//Rules

start    :   start expr  '\n'       {  printf("%s\n", $2);   }
         |	{     }
	 |   error '\n'		    {yyerrok; }   
         ;

expr     :    expr '#' expr    {$$=strcat($1,$3);}
         |    REVERSE '(' expr ')'  {$$=reverse($3);}
         |    STRING   {$$=$1;}


%%     
	

	//programs


char *reverse(char *str1)
{
    int l, i; 
    char *begin_ptr, *end_ptr, ch; 
  
    //length of the string 
    l = strlen(str1); 
  
    // Set the begin_ptr and end_ptr to start of string
    begin_ptr = str1; 
    end_ptr = str1; 
  
    // Move the end_ptr to the last character 
    for (i = 0; i < l - 1; i++) 
        end_ptr++; 
  

    // Swap the char from start and end 
    for (i = 0; i < l / 2; i++) { 
    
        // swap character 
        ch = *end_ptr; 
        *end_ptr = *begin_ptr; 
        *begin_ptr = ch; 
  
        // update pointers
        begin_ptr++; 
        end_ptr--; 
    }

    return str1;
}



int main(void) {
    yyparse();
    return 0;
}
