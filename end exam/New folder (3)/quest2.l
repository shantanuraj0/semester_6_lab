%{
	#include "y.tab.h"
%}


%%
[ \t]+
[,()\n]				{ 
					return *yytext; 
				      }

[0-9]+[.][0-9]+   		{
						yylval.val = atof(yytext);
						return NUM;
					}

[0-9]+				      { 
						yylval.val = atoi(yytext); 
						return NUM; 
					}

[^ 0-9(, )\t\n]+	{
						if(strcmp(yytext, "regular") == 0) 
							return REGULAR;

						int flag = 1; 
						char* str = "simple";

						for(int i=0; yytext[i]!='\0'; i++) {
							if(yytext[i] != str[i]) 
								flag = 0;
						} 
						if(flag) 
							return SIMPLE;

						
						flag = 1; 
						str = "compound";

						for(int i=0; yytext[i]!='\0'; i++) {
							if(yytext[i] != str[i]) 
								flag = 0;
						} 
						if(flag) 
							return COMPOUND;
 					}

%%
int yywrap(void) {
	return 1;
}
