%{ 
#include<stdio.h> 
int line_count = 1, empty_line_count  ,keywords=0 , braces=0;
int chr=0, multi_line_comment = 0, single_line_comment = 0;
int comments_count , flag = 0,codes=0;
%}

%x COMMENT
%%

 /*count number of empty lines*/
^(?:[\t ]*(?:\r?\n|\r))+ {++empty_line_count;}


 /* count number of braces*/
[(]|[)]|[[]|[]]|[{]|[}] braces++;


 /* count number of comments in the given Input */

"/*" {if(flag == 0)flag++;}
"*/" {if(flag == 1)flag=0;multi_line_comment++;}
"//".* {if(flag == 0)single_line_comment++;}

 /*count number of characters*/
. {if(flag == 0)chr++;}


 /*count number of keywords*/
("int "|"char "|"bool "|"float "|printf|scanf|void|for|do|while|if|else|return|void) {keywords++;}

 
 /*count number of  code lines*/
.+"/*".*"*/".*\n { codes++; }
.*"/*".*"*/".+\n { codes++; }
.+"/*".*\n       { codes++; BEGIN COMMENT; }
.\n              { codes++; }
%% 
  


void main(int argc, char **argv)
{ 
 
 /* either pass an file as an argument or give input*/
  FILE *file;
  if (argc == 2 && (file = fopen(argv[1], "r"))) {
    yyin = file;
    }
  else
    yyin=stdin;
  
    
    yylex(); 
    printf("\n Number of Blank Lines : %d" , empty_line_count);

    comments_count = multi_line_comment +single_line_comment ;
    printf("\n Number of comments line : %d", comments_count );
    
    printf("\n Number of Code lines : %d" , codes);
    printf("\n Number of braces : %d",braces/2);
    printf("\n Number of keywords : %d",keywords); 
    printf("\n Number of other characters : %d\n", chr); 
}
int yywrap()
{
return(1);
} 
